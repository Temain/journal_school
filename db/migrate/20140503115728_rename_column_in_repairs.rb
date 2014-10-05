class RenameColumnInRepairs < ActiveRecord::Migration
  def change
    rename_column :repairs, :replaced_item_id, :spare_id
  end
end
