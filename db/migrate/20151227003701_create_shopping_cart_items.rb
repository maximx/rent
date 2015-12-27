class CreateShoppingCartItems < ActiveRecord::Migration
  def change
    create_table :shopping_cart_items do |t|
      t.integer :shopping_cart_id
      t.integer :item_id
      t.float :price
      t.float :deliver_fee
    end
    add_index :shopping_cart_items, [ :shopping_cart_id, :item_id ]
  end
end
