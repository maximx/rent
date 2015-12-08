class PagesController < ApplicationController
  layout 'user', only: [ :index ]

  before_action :set_title, :set_pages_meta_tags, except: [ :index ]

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


  private

    def set_title
      @title = t("controller.pages.action.#{action_name}")
    end

    def set_pages_meta_tags
      set_meta_tags(
        title: @title,
        og: { title: @title }
      )
    end
end
