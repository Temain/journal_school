# == Schema Information
#
# Table name: relocations
#
#  id                :integer          not null, primary key
#  new_department_id :integer          not null
#  old_department_id :integer
#

FactoryGirl.define do
  factory :relocation do |f|
    f.new_department { FactoryGirl.create(:department) }
    f.old_department { FactoryGirl.create(:department) }
    #f.after_create {|r| FactoryGirl.create(:journal_record, :journalable => r)}
  end
end
