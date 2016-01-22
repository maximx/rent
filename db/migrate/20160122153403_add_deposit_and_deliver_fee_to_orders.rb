class AddDepositAndDeliverFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deposit, :float
    add_column :orders, :deliver_fee, :float
  end
end
