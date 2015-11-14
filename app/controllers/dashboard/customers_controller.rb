class Dashboard::CustomersController < ApplicationController
  before_action :login_required
  before_action :find_customer, only: [ :edit, :update, :destroy ]

  def index
  end

  def new
    @customer = current_user.customers.build
  end

  def create
    @customer = current_user.customers.build customer_params

    if @customer.save
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @customer.update customer_params
    else
      render :edit
    end
  end

  def destroy
    @customer.destroy
    redirect_to dashboard_customers_path
  end

  private

    def customer_params
      params.require(:customer).permit(:email)
    end

    def find_customer
      @customer = current_user.customers.find params[:id]
    end
end
