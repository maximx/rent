class AddSendPeriodToShoppingCartItems < ActiveRecord::Migration
  def change
    add_column :shopping_cart_items, :send_period, :integer
  end
end
