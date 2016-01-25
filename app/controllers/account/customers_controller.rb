class Account::CustomersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource through: :current_user, except: [ :index ]
  before_action :load_profile, only: [ :show, :edit, :update ]

  def index
    authorize! :index, Customer
    @consumers = current_user.consumers(search_params)
                             .paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @profile = @customer.build_profile
  end

  def create
    if @customer.save
      redirect_to account_customer_path @customer
    else
      flash[:alert] = t('controller.action.create.fail')
      render 'account/customers/new'
    end
  end

  def edit
  end

  def update
    if @customer.update customer_params
      redirect_url = params[:redirect_url].present? ? params[:redirect_url] : account_customer_path(@customer)
      redirect_to redirect_url,
                  notice: t('controller.action.update.success', name: @customer.account)
    else
      flash[:alert] = t('controller.action.create.fail')
      render 'account/customers/edit'
    end
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

    def load_profile
      @profile = @customer.profile
    end
end
