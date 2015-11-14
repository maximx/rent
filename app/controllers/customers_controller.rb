class CustomersController < ApplicationController
  before_action :login_required
  before_action :find_customer, only: [ :update, :destroy ]

  def create
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      redirect_to dashboard_customer_path @customer
    else
      render 'dashboard/customers/new'
    end
  end

  def update
    if @customer.update customer_params
      redirect_to dashboard_customer_path @customer
    else
      render 'dashboard/customers/edit'
    end
  end

  def destroy
    @customer.destroy
    redirect_to dashboard_customers_path
  end

  private

    def customer_params
      params.require(:customer).permit(
        :email,
        profile_attributes: [ :id, :name, :address, :phone ]
      )
    end

    def find_customer
      @customer = current_user.customers.find params[:id]
    end
end
