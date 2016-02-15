class AddPriceDeliverFeeDepositToOrderLenders < ActiveRecord::Migration
  def change
    add_column :order_lenders, :price, :float
    add_column :order_lenders, :deposit, :float
    add_column :order_lenders, :deliver_fee, :float
  end
end
