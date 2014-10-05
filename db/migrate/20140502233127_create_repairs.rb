class CreateRepairs < ActiveRecord::Migration
  def change
    create_table :repairs do |t|
      t.integer :replaced_item_id
      t.string  :reason
    end
  end
end
