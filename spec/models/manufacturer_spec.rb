# == Schema Information
#
# Table name: manufacturers
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  abbreviation :string(255)
#

require 'spec_helper'

describe Manufacturer do
  it "has a valid factory" do
    FactoryGirl.create(:manufacturer).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:manufacturer, name: nil).should_not be_valid
  end

  it "does not allow duplicate" do
    manufacturer = FactoryGirl.create(:manufacturer)
    FactoryGirl.build(:manufacturer, name: manufacturer.name).should_not be_valid
  end
end
