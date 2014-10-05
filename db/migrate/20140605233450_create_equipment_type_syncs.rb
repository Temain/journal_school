class CreateEquipmentTypeSyncs < ActiveRecord::Migration
  def change
    create_table :equipment_type_syncs, id: false do |t|
      t.integer :equipment_type_id, null: false
      t.string  :alias,             null: false
    end
  end
end
