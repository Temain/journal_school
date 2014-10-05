class RemoveColumnFromRepairs < ActiveRecord::Migration
  def change
    remove_column :repairs, :replaced_item_id
  end
end
