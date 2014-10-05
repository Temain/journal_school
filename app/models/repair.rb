# == Schema Information
#
# Table name: repairs
#
#  id     :integer          not null, primary key
#  reason :string(255)
#

class Repair < ActiveRecord::Base
  belongs_to :spare
  has_and_belongs_to_many :spares
  has_one    :journal_record, as: :journalable
end
