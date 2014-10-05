# == Schema Information
#
# Table name: manufacturers
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  abbreviation :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :manufacturer do |f|
    f.name { Faker::Company.name }
    f.abbreviation "ABBA"
  end
end
