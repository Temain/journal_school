# == Schema Information
#
# Table name: journal_records
#
#  id               :integer          not null, primary key
#  journalable_id   :integer
#  journalable_type :string(255)
#  equipment_id     :integer          not null
#  user_id          :integer
#  action_date      :datetime
#

require 'spec_helper'

describe JournalRecord do
  it "has a valid factory" do
    FactoryGirl.create(:journal_record).should be_valid
  end
end
