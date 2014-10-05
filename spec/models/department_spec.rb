# == Schema Information
#
# Table name: departments
#
#  id                     :integer          not null, primary key
#  name                   :string(255)      not null
#  materially_responsible :string(255)
#  phone_number           :integer
#

require 'spec_helper'

describe Department do
  it "has a valid factory" do
    FactoryGirl.create(:department).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:department, name: nil).should_not be_valid
  end

  it "does not allow duplicate" do
    department = FactoryGirl.create(:department)
    FactoryGirl.build(:department, name: department.name).should_not be_valid
  end
end
