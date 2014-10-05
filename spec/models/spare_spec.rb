# == Schema Information
#
# Table name: spares
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  equipment_type_id :integer
#

require 'spec_helper'

describe Spare do
  it "has a valid factory" do
    FactoryGirl.create(:spare).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:spare, name: nil).should_not be_valid
  end

  it "does not allow duplicate" do
    spare = FactoryGirl.create(:spare)
    FactoryGirl.build(:spare, name: spare.name).should_not be_valid
  end
end
