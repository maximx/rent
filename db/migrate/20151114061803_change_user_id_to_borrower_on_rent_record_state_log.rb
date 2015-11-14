class ChangeUserIdToBorrowerOnRentRecordStateLog < ActiveRecord::Migration
  def change
    rename_column :rent_record_state_logs, :user_id, :borrower_id
    add_column :rent_record_state_logs, :borrower_type, :string
    add_index :rent_record_state_logs, [ :borrower_id, :borrower_type ]
  end
end
