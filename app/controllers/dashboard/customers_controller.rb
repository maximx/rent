class Dashboard::CustomersController < ApplicationController
  before_action :login_required
  before_action :find_customer, only: [ :show, :edit ]

  def index
  end

  def show
  end

  def new
    @customer = current_user.customers.build
    @customer.build_profile
  end

  def edit
  end

  private

    def find_customer
      @customer = current_user.customers.find params[:id]
    end
end
