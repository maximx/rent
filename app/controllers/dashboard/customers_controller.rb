class Dashboard::CustomersController < ApplicationController
  before_action :login_required

  def index
  end

  def new
    @customer = current_user.customers.build
  end

  def edit
    @customer = current_user.customers.find params[:id]
  end
end
