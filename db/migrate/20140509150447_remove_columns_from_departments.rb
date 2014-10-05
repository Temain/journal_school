class RemoveColumnsFromDepartments < ActiveRecord::Migration
  def change
    remove_column :departments, :created_at
    remove_column :departments, :updated_at
  end
end
