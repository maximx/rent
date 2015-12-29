class ShoppingCarts::ItemsController < ApplicationController
  before_action :load_shopping_cart
  load_and_authorize_resource except: [ :index, :search ]

  # post items/:id/add
  def add
    @shopping_cart.add @item
  end

  # delete items/:id/remove
  def remove
    @shopping_cart.remove @item
    redirect_to :back
  end
end
