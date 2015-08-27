class ChangeDeliverIdNotNullOnRentRecords < ActiveRecord::Migration
  def change
    change_column :rent_records, :deliver_id, :integer, null: false
  end
end
