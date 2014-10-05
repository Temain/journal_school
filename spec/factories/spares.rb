# == Schema Information
#
# Table name: spares
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  equipment_type_id :integer
#

FactoryGirl.define do
  factory :spare do |f|
    f.name { Faker::Lorem.word }
    equipment_type
  end
end
