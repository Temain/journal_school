class RenameJournalTable < ActiveRecord::Migration
  def change
    rename_table :journal, :journal_records
  end
end
