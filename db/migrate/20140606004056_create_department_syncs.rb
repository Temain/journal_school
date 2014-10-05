class CreateDepartmentSyncs < ActiveRecord::Migration
  def change
    create_table :department_syncs, id: false do |t|
      t.integer :department_id, null: false
      t.string  :alias, null: false
    end
  end
end
