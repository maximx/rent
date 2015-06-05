class AddPriceToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :price, :float
  end
end
