class ToursController < ApplicationController
  before_action :set_title, :set_pages_meta_tags

  def index
  end

  def calendar
  end

  def state
  end

  def contract
  end

  def dashboard
  end

  private
    def set_title
      @title = "#{t('controller.name.tours')} - #{t("helpers.tours.#{action_name}")}"
    end

    def set_pages_meta_tags
      set_meta_tags title: @title,
                    og: { title: @title }
    end
end
