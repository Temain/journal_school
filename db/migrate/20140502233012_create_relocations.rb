class CreateRelocations < ActiveRecord::Migration
  def change
    create_table :relocations do |t|
      t.integer :department_id, null: false
    end
  end
end
