class AddAasmStateChangedTimeToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :booking_at, :datetime
    add_column :rent_records, :renting_at, :datetime
    add_column :rent_records, :withdrawed_at, :datetime
    add_column :rent_records, :returned_at, :datetime
  end
end
