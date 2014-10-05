class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string  :name, null: false
      t.string  :materially_responsible
      t.integer :phone_number

      t.timestamps
    end
  end
end
