class DropTableRecordStateLogs < ActiveRecord::Migration
  def change
    drop_table :record_state_logs
  end
end
