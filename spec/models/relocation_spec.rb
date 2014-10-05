# == Schema Information
#
# Table name: relocations
#
#  id                :integer          not null, primary key
#  new_department_id :integer          not null
#  old_department_id :integer
#

require 'spec_helper'

describe Relocation do
  it "has a valid factory" do
    FactoryGirl.create(:relocation).should be_valid
  end
end
