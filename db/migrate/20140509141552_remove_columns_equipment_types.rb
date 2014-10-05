class RemoveColumnsEquipmentTypes < ActiveRecord::Migration
  def change
    remove_column :equipment_types, :manufacturer
    remove_column :equipment_types, :abbreviation
  end
end
