class AddColumnsToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :item_price, :float
    add_column :rent_records, :rent_days, :integer
    add_column :rent_records, :item_deposit, :float
    add_column :rent_records, :item_down_payment, :float
  end
end
