class AddFreeDaysToShoppingCartItems < ActiveRecord::Migration
  def change
    add_column :shopping_cart_items, :free_days, :integer, default: 0
  end
end
