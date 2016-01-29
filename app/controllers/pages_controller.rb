class PagesController < ApplicationController
  layout 'user', only: [:index]

  before_action :set_title, :set_title_meta_tag, except: [:index]

  def index
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
    @service_email = "service@guangho.tw"
  end

  private
    def set_title
      @title = t("controller.pages.action.#{action_name}")
    end
end
