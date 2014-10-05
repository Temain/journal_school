class AddColumnToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :manufacturer_id, :integer
  end
end
