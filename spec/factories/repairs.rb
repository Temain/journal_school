# == Schema Information
#
# Table name: repairs
#
#  id     :integer          not null, primary key
#  reason :string(255)
#

FactoryGirl.define do
  factory :repair do |f|
    f.reason { Faker::Lorem.sentence }
  end
end
