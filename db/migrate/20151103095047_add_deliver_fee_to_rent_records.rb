class AddDeliverFeeToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :deliver_fee, :float
  end
end
