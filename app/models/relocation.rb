# == Schema Information
#
# Table name: relocations
#
#  id                :integer          not null, primary key
#  new_department_id :integer          not null
#  old_department_id :integer
#

class Relocation < ActiveRecord::Base
  belongs_to :new_department, class_name: Department
  belongs_to :old_department, class_name: Department
  has_one    :journal_record, as: :journalable
end
