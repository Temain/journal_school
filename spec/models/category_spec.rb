# == Schema Information
#
# Table name: categories
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

require 'spec_helper'

describe Category do
  it "has a valid factory" do
    FactoryGirl.create(:category).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:category, name: nil).should_not be_valid
  end

  it "does not allow duplicate" do
    category = FactoryGirl.create(:category)
    FactoryGirl.build(:category, name: category.name).should_not be_valid
  end
end
