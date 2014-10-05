class CreateRepairsSparesTable < ActiveRecord::Migration
  def change
    create_table :repairs_spares, id: false do |t|
      t.belongs_to :repair
      t.belongs_to :spare
    end
  end
end
