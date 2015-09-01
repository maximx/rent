class AddInfoToRentRecordStateLogs < ActiveRecord::Migration
  def change
    add_column :rent_record_state_logs, :info, :string
  end
end
