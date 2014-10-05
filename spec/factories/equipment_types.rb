# == Schema Information
#
# Table name: equipment_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  category_id :integer          not null
#

FactoryGirl.define do
  factory :equipment_type do |f|
    f.name { Faker::Commerce.product_name }
    category
    #association :category, factory: :category, strategy: :build
  end
end
