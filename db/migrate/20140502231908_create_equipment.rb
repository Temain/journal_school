class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.integer :equipment_type_id, null: false
      t.integer :department_id,     null: false
      t.integer :inventory_number
      t.boolean :writed_off,        default: false

      t.timestamps
    end
  end
end
