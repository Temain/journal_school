class AddAndRemoveColumnsInJournalRecords < ActiveRecord::Migration
  def change
    add_column :journal_records, :user_id, :integer
    add_column :journal_records, :action_date, :datetime

    remove_column :journal_records, :note
    remove_column :journal_records, :created_at
    remove_column :journal_records, :updated_at
  end
end
