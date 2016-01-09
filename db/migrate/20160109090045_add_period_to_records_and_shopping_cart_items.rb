class AddPeriodToRecordsAndShoppingCartItems < ActiveRecord::Migration
  def change
    add_column :records, :item_period, :integer
    add_column :shopping_cart_items, :period, :integer, default: 1
  end
end
