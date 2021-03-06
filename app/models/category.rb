# == Schema Information
#
# Table name: categories
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class Category < ActiveRecord::Base
  has_many :equipment_types

  validates :name, presence: true, uniqueness: true
end
