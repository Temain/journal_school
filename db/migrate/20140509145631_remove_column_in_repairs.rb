class RemoveColumnInRepairs < ActiveRecord::Migration
  def change
    remove_column :repairs, :spare_id
  end
end
