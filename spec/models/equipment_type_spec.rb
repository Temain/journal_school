# == Schema Information
#
# Table name: equipment_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  category_id :integer          not null
#

require 'spec_helper'

describe EquipmentType do
  it "has a valid factory" do
    FactoryGirl.create(:equipment_type).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:equipment_type, name: nil).should_not be_valid
  end

  it "does not allow duplicate" do
    equipment_type = FactoryGirl.create(:equipment_type)
    FactoryGirl.build(:equipment_type, name: equipment_type.name).should_not be_valid
  end
end
