class AddDepositToShoppingCartItems < ActiveRecord::Migration
  def change
    add_column :shopping_cart_items, :deposit, :float, default: 0
  end
end
