class VectorsController < ApplicationController
  def index
    if request.xhr?
      user = User.find_by_account(params[:user_account])
      @vectors = Subcategory.find(params[:subcategory_id])
                            .vectors
                            .where(user: user)
                            .includes(:tag, [selections: :tag])
      @input_name = 'selections[]'
      @selections = params[:selections] if params[:selections].present?
      render partial: 'account/vectors/selections',
             locals: { vectors: @vectors, selections: @selections, input_name: @input_name }
    end
  end
end
