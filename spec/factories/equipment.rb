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

FactoryGirl.define do
  factory :equipment do |f|
    model { Faker::Lorem.word }
    equipment_type
    department
    manufacturer
    f.inventory_number { Faker::Number.number(11) }
  end
end
