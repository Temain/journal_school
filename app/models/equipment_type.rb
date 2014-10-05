# == Schema Information
#
# Table name: equipment_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  category_id :integer          not null
#

class EquipmentType < ActiveRecord::Base
  belongs_to :category
  has_many   :equipments
  has_many   :spares
  has_many   :equipment_type_syncs

  validates :name, presence: true, uniqueness: true
end
