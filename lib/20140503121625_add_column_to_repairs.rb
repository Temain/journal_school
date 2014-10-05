class AddColumnToRepairs < ActiveRecord::Migration
  def change
    add_column :repairs, :spare_id, :integer
  end
end
