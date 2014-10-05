class CreateSpares < ActiveRecord::Migration
  def change
    create_table :spares do |t|
      t.string  :name
      t.integer :category_id
    end
  end
end
