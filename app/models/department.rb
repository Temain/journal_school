# == Schema Information
#
# Table name: departments
#
#  id                     :integer          not null, primary key
#  name                   :string(255)      not null
#  materially_responsible :string(255)
#  phone_number           :integer
#

class Department < ActiveRecord::Base
  has_many :equipments
  has_many :department_syncs

  validates :name, presence: true, uniqueness: true

  default_scope -> { order('name ASC') }

  private

    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      @count = 0

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        if row["name"]
          unless Department.find_by_name(row["name"])
            chief = if row["chief"]
              row["chief"].split.map { |x| Unicode::capitalize(x) }.join(" ")
            end
            department = Department.create({
              index: row["index"].nil? ? "" : row["index"].strip,
              code:  row["code"].nil? ? "" : row["code"].strip,
              name:  Unicode::capitalize(row["name"]),
              chief: chief
            })

            if row["alias"]
              row["alias"].split(';').map { |al| department.department_syncs << DepartmentSync.new(alias: al.strip) }
            end

            @count += 1
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

end
