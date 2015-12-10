class Account::SubcategoriesController < ApplicationController
  before_action :login_required
  load_and_authorize_resource through: :current_user

  def index
    #TODO: vectors 只選出 user
    @subcategories = @subcategories.includes(vectors: :tag).uniq
  end
end
