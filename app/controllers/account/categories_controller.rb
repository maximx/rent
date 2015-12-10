class Account::CategoriesController < ApplicationController
  before_action :login_required
  load_and_authorize_resource

  def index
    @categories = @categories.includes(subcategories: [ vectors: :tag ])
  end
end
