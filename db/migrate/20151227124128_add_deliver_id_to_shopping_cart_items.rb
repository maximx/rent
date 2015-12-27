class AddDeliverIdToShoppingCartItems < ActiveRecord::Migration
  def change
    add_column :shopping_cart_items, :deliver_id, :integer
  end
end
