class RequirementsController < ApplicationController
  include RentCloudinary

  before_action :login_required, except: [ :index, :show ]
  before_action :find_requirement, only: [ :edit, :update, :destroy ]
  before_action :set_public_id, only: [ :create, :update ]

  def index
    @requirements = Requirement.includes(:demander).all
  end

  def show
    @requirement = Requirement.find(params[:id])
  end

  def new
    @requirement = current_user.requirements.build
    @requirement.pictures.build
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to requirement_path(@requirement)
    else
      render :new
    end
  end

  def edit
    @requirement.pictures.build unless @requirement.pictures.exists?
  end

  def update
    if @requirement.update(requirement_params)
      redirect_to requirement_path(@requirement)
    else
      render :edit
    end
  end

  def destroy
    @requirement.destroy
    redirect_to settings_requirements_path
  end

  private

  def requirement_params
    params.require(:requirement).permit(
      :name, :description, :email, :phone, :address,
      :price, :started_at, :ended_at,
      pictures_attributes: [ :public_id ]
    )
  end

  def find_requirement
    @requirement = current_user.requirements.find(params[:id])
  end

end
