# == Schema Information
#
# Table name: journal_records
#
#  id               :integer          not null, primary key
#  journalable_id   :integer
#  journalable_type :string(255)
#  equipment_id     :integer          not null
#  user_id          :integer
#  action_date      :datetime
#

class JournalRecord < ActiveRecord::Base
  belongs_to :equipment
  belongs_to :user
  belongs_to :journalable, polymorphic: true

  default_scope -> { order('action_date DESC') }

  def full_text
    if journalable.instance_of?(Relocation)
      "Передан подразделению #{journalable.new_department.name}"
    else
      "Отправлен в ремонт"
    end
  end
end
