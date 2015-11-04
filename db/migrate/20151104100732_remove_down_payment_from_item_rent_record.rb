class RemoveDownPaymentFromItemRentRecord < ActiveRecord::Migration
  def change
    remove_column :items, :down_payment, :float
    remove_column :rent_records, :item_down_payment, :float
  end
end
