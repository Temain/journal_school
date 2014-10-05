class CreateJournal < ActiveRecord::Migration
  def change
    create_table :journal do |t|
      t.integer :journalable_id
      t.string  :journalable_type
      t.integer :equipment_id, null: false
      t.string  :note

      t.timestamps
    end
  end
end
