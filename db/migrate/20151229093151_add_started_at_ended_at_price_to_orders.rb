class AddStartedAtEndedAtPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :started_at, :datetime
    add_column :orders, :ended_at, :datetime
    add_column :orders, :price, :float
  end
end
