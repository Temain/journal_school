class AddColumnToRelocations < ActiveRecord::Migration
  def change
    add_column :relocations, :old_department_id, :integer
    rename_column :relocations, :department_id, :new_department_id
  end
end
