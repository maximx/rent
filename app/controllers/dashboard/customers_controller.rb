class Dashboard::CustomersController < ApplicationController
  before_action :login_required
  before_action :find_customer, :find_profile, only: [ :show, :edit, :update, :destroy ]

  def index
    @consumers = current_user.consumers(search_params)
                  .paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @customer = current_user.customers.build
    @profile = @customer.build_profile
  end

  def create
    @customer = current_user.customers.build(customer_params)

    if @customer.save
      redirect_to dashboard_customer_path @customer
    else
      render 'dashboard/customers/new'
    end
  end

  def edit
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

    def search_params
      if !params[:query].blank? and ['email', 'name', 'phone'].include?(params[:type])
        'email' == params[:type] ?
          Hash[ params[:type], params[:query] ] : Hash[:profiles, Hash[ params[:type], params[:query] ] ]
      end
    end

    def find_customer
      @customer = current_user.customers.find params[:id]
    end

    def find_profile
      @profile = @customer.profile
    end
end
