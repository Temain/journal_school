class RenameColumnInSpares < ActiveRecord::Migration
  def change
    rename_column :spares, :category_id, :equipment_type_id
  end
end
