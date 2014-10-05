class ReportsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def report_by_department
    #if params[:department_id]
      @equipment = Equipment.search_by_department(params[:department_id].first, params[:start_date], params[:end_date])
      count = @equipment.count
      report = ThinReports::Report.create layout: File.join(Rails.root, 'app', 'reports', 'report_by_department.tlf') do |r|
        r.start_new_page do |page|
          page.values department: Department.find(params[:department_id]).first.name,
                   date: "с #{params[:start_date]}г. по #{params[:end_date]}г."

          @equipment.each_with_index do |eq, index|
            page.list(:list).add_row do |row|
              row.values number: "#{index + 1}.",
                         equipment: eq.full_name,
                         inventory_number: eq.inventory_number,
                         action_date: "#{eq.journal_records.where(journalable_type: 'Repair').last.action_date.strftime('%d.%m.%Y')}г."
            end
          end
        end
     # end

     # redirect_to request.referer
    end

    send_data report.generate, filename:    'report_by_department.pdf',
                               type:        'application/pdf',
                               disposition: 'attachment'
  end

  def report_by_spare
    @spare = Spare.find_by_name(params[:spare])
    if @spare
      report = ThinReports::Report.create layout: File.join(Rails.root, 'app', 'reports', 'report_by_spare.tlf') do |r|
        r.start_new_page do |page|
          page.values title: "Список оборудования с замененной деталью #{ @spare.name }"

          @spare.repairs.each_with_index do |repair, index|
            page.list(:list).add_row do |row|
              row.values number: "#{index + 1}.",
                         equipment: repair.journal_record.equipment.full_name,
                         department: repair.journal_record.equipment.department.name,
                         inventory_number: repair.journal_record.equipment.inventory_number,
                         date: "#{repair.journal_record.action_date.strftime('%d.%m.%Y')}г."
            end

          end
        end
      end

      send_data report.generate, filename:    'report_by_spare.pdf',
                                 type:        'application/pdf',
                                 disposition: 'attachment'
    end
  end

  def report_by_equipment
    @equipment = Equipment.find(params[:equipment_id])

    report = ThinReports::Report.create layout: File.join(Rails.root, 'app', 'reports', 'report_by_equipment.tlf') do |r|
      r.start_new_page do |page|
        page.values equipment: "#{@equipment.full_name}",
                    department: "#{@equipment.department.name}",
                    chief: "Руководитель:  #{@equipment.department.chief}",
                    mat: "Материально ответственный:  #{@equipment.department.materially_responsible}",
                    phone_number: "Номер телефона:  #{ local_phone_number @equipment.department.phone_number }"

        @equipment.journal_records.each do |record|
          event = record.journalable
          page.list(:list).add_row do |row|
            row.values event_date: "#{record.action_date.strftime('%d.%m.%Y')}г.",
                       event: event.instance_of?(Repair) ? event.reason : "Перемещен из подразделения \"#{event.old_department.name}\"
                                                                     в подразделение \"#{event.new_department.name}\""
          end

        end
      end
    end

    send_data report.generate, filename:    'report_by_equipment.pdf',
                               type:        'application/pdf',
                               disposition: 'attachment'
  end

end
