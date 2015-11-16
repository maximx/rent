class Dashboard::CustomersController < ApplicationController
  before_action :login_required
  before_action :find_customer, :find_profile, only: [ :show, :edit ]

  def index
    @consumers = current_user.consumers.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @customer = current_user.customers.build
    @profile = @customer.build_profile
  end

  def edit
  end

  private

    def find_customer
      @customer = current_user.customers.find params[:id]
    end

    def find_profile
      @profile = @customer.profile
    end
end
