# == Schema Information
#
# Table name: departments
#
#  id                     :integer          not null, primary key
#  name                   :string(255)      not null
#  materially_responsible :string(255)
#  phone_number           :integer
#

FactoryGirl.define do
  factory :department do |f|
    f.name { Faker::Commerce.department }
    f.materially_responsible { Faker::Name.name }
    f.phone_number { Faker::PhoneNumber.subscriber_number(3) }
  end
end
