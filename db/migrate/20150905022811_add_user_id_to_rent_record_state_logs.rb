class AddUserIdToRentRecordStateLogs < ActiveRecord::Migration
  def change
    add_column :rent_record_state_logs, :user_id, :integer
  end
end
