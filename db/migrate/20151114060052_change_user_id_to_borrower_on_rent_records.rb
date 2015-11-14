class ChangeUserIdToBorrowerOnRentRecords < ActiveRecord::Migration
  def change
    rename_column :rent_records, :user_id, :borrower_id
    add_column :rent_records, :borrower_type, :string
    add_index :rent_records, [ :borrower_id, :borrower_type ]
  end
end
