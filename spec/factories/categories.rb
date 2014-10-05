# == Schema Information
#
# Table name: categories
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

FactoryGirl.define do
  factory :category do |f|
    f.name { |n| "Category#{n}" }
  end
end
