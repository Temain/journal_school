# == Schema Information
#
# Table name: equipment
#
#  id                :integer          not null, primary key
#  equipment_type_id :integer          not null
#  department_id     :integer          not null
#  inventory_number  :integer
#  writed_off        :boolean          default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#  manufacturer_id   :integer
#  model             :string(255)
#

class Equipment < ActiveRecord::Base
  belongs_to :department
  belongs_to :equipment_type
  belongs_to :manufacturer
  has_many   :journal_records

  #validates :model, presence: true
  validates :inventory_number, presence: true, length: { maximum: 14 }

  validates :department, presence: true
  validates :equipment_type, presence: true
  #validates :manufacturer, presence: true
  #validate :when_manufacturer_empty

  accepts_nested_attributes_for :manufacturer

  default_scope -> { order('updated_at DESC') }

  def full_name
    "#{equipment_type.name} #{ manufacturer.nil? ? "" : manufacturer.name } #{ model ? model : "" }"
  end

  def to_partial_path
    'equipment/item'
  end

  private

    def self.search(search)
      if search
        joins(:equipment_type, :manufacturer, :department)
          .where("departments.name LIKE ? OR model LIKE ? OR equipment_types.name LIKE ? OR inventory_number LIKE ? OR manufacturers.name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%","%#{search}%")
          .includes(:manufacturer, :equipment_type, :department)
      else
        includes(:manufacturer, :equipment_type, :department)
      end
      .where(writed_off: false)
    end

    def self.search_for_create(search)
      if search
        joins(:equipment_type, :manufacturer)
          .where("model LIKE ? OR equipment_types.name LIKE ? OR manufacturers.name LIKE ?", "%#{search}%","%#{search}%","%#{search}%")
          .includes(:manufacturer, :equipment_type)
      else
        includes(:manufacturer, :equipment_type)
      end
    end

    def self.search_by_department(department_id, start_date, end_date)
      if department_id && start_date && end_date
        joins(:equipment_type, :manufacturer, :department, :journal_records)
        .where("departments.id = ? AND journal_records.action_date >= ? AND journal_records.action_date <= ? AND journal_records.journalable_type = ?", "#{department_id}",
               "#{Date.strptime(start_date, '%d.%m.%Y') - 1.day}","#{Date.strptime(end_date, '%d.%m.%Y') + 1.day}", "Repair").reorder('equipment_types.name, manufacturers.name ASC')
        .where(writed_off: false)
        .includes(:manufacturer, :equipment_type, :department, :journal_records)
      #else
      #  includes(:manufacturer, :equipment_type, :department) #.where(journal_records: { journalable_type: 'Repair' })
      end
    end

    #def when_manufacturer_empty
    #  @errors.add(:manufacturer, 'не может быть пустым') if manufacturer_id.nil?
    #end

    def self.import(session, file)
      format(file)
      save_import(session)
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        #when ".csv" then Csv.new(file.path, nil, :ignore)
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def self.format file
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      @rows = [["Тип", "Производитель", "Модель", "Инвентарный номер", "Подразделение"]]

      #(2..spreadsheet.last_row).each do |i|
      (2..1000).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        if row["name"]
          @row = { name: [], manufacturer: [], model: [],
                   inventory_number: [row["inventory_number"].strip],
                   department: [] }
          check_existence(row)
          parse(row["name"])
          @rows << @row.values.map { |c| Unicode::capitalize(c.join(" ")) }
        end
      end
      write @rows, "formated.xls"
    end

    def self.parse name
      name.split.each_with_index do |word, index|
        if word =~ /"[а-яА-Я]+.+"/
          if @row[:manufacturer].frozen?
            @row[:model] << word.strip
          else
            @row[:manufacturer] << word.strip
          end
        elsif word =~ /[a-zA-Z0-9]+\/|-?[0-9]+|[a-zA-Z]{1,3}[0-9]+|[0-9]{1,3}[a-zA-Z]+/
          @row[:model] << word.strip
        elsif word =~ /[a-zA-Z]+|".+|.+"|[a-zA-Z]+-[a-zA-Z]+/
          if @row[:manufacturer].frozen?
            @row[:model] << word.strip
          else
            @row[:manufacturer] << word.strip
          end
        elsif word =~ /[0-9]+/ || (word =~ /[А-Я]+/ && index > 0)
          break
        else
          @row[:name] << word.strip unless @row[:name].frozen?
        end
      end
      @row
    end

    def self.check_existence row
      temp = find_equipment_type(row["name"])
      find_manufacturer(temp)
      find_department(row["department_name"])
    end

    def self.find_equipment_type name
      EquipmentTypeSync.all.each do |type_sync|
        if name.include? type_sync.alias
          name.gsub! type_sync.alias, ''
          @row[:name] = [type_sync.equipment_type.name]
          @row[:name].freeze
          break
        elsif name.include? type_sync.equipment_type.name
          name.gsub! type_sync.equipment_type.name, ''
          @row[:name] = [type_sync.equipment_type.name]
          @row[:name].freeze
          break
        end
      end
      name
    end

    def self.find_manufacturer name
      Manufacturer.all.each do |manufacturer|
        if name.include? manufacturer.name
          name.gsub! manufacturer.name, ''
          @row[:manufacturer] = [manufacturer.name]
          @row[:manufacturer].freeze
          break
        end
      end
      name
    end

    def self.find_department name
      DepartmentSync.all.each do |department_sync|
        if name.include? department_sync.alias
          @row[:department] = [department_sync.department.name]
          @row[:department].freeze
          break
        end
      end
      name
    end

    def self.write rows, file_name
      book = Spreadsheet::Workbook.new
      write_sheet = book.create_worksheet
      rows.each_with_index do |row, index|
        write_sheet.row(index).replace row
        #puts UnicodeUtils.downcase(type[0]), type[1]
      end

      format = Spreadsheet::Format.new :color=> :black, :pattern_fg_color => :yellow, :pattern => 1
      (0..4).each { |i| write_sheet.row(0).set_format(i, format) }
      book.write "public/#{file_name}"
    end

    def self.save_import(session)
      results = { imported: 0, not_imported: -1, updated: 0, not_updated: 0 } # not_imported -1 because first row is header
      @not_imported_rows = []
      @rows.each_with_index do |row, index|
        eq = {
          equipment_type: EquipmentType.find_by_name(row[0]),
          manufacturer: Manufacturer.find_by_name(row[1]) || Manufacturer.create(name: row[1]),
          model: row[2],
          inventory_number: row[3],
          department: Department.find_by_name(row[4])
          #writed_off: false
        }
        finded = Equipment.find_by_inventory_number(row[3])
        if finded
          finded.assign_attributes(eq) if eq[:department] && eq[:equipment_type] && eq[:inventory_number] && index !=0
          if finded.changed?
            if finded.save
              results[:updated] += 1
            else
              results[:not_updated] += 1
            end
          else
            results[:not_updated] += 1
          end
        else
          if eq[:department] && eq[:equipment_type] && eq[:inventory_number] && index !=0
            if Equipment.create(eq)
              results[:imported] += 1
            else
              results[:not_imported] += 1
              @not_imported_rows << row
            end
          else
            results[:not_imported] += 1
            @not_imported_rows << row
          end
        end
      end
      write @not_imported_rows, "not_imported.xls"
      results
    end

end
