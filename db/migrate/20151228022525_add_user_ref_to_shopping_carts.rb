class AddUserRefToShoppingCarts < ActiveRecord::Migration
  def change
    add_reference :shopping_carts, :user, polymorphic: true, index: true
  end
end
