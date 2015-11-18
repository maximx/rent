class RenameRentRecordsToRecords < ActiveRecord::Migration
  def change
    rename_table :rent_records, :records
    rename_column :rent_record_state_logs, :rent_record_id, :record_id
    rename_column :reviews, :rent_record_id, :record_id

    rename_table :rent_record_state_logs, :record_state_logs
  end
end
