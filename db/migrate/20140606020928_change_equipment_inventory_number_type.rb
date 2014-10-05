class ChangeEquipmentInventoryNumberType < ActiveRecord::Migration
  def change
    change_column :equipment, :inventory_number, :string
  end
end
