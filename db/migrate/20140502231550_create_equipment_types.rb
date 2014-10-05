class CreateEquipmentTypes < ActiveRecord::Migration
  def change
    create_table :equipment_types do |t|
      t.string  :name       ,  null: false
      t.integer :category_id,  null: false
      t.string  :manufacturer, null: false
      t.string  :abbreviation
    end
  end
end
