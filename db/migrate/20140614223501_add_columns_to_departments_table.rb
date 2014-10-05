class AddColumnsToDepartmentsTable < ActiveRecord::Migration
  def change
    add_column :departments, :index, :string
    add_column :departments, :code,  :string
    add_column :departments, :chief, :string
  end
end
