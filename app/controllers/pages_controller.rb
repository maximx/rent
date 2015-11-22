class PagesController < ApplicationController
  layout 'user', only: [ :index ]

  def index
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
    @admin = User.find 1
  end
end
