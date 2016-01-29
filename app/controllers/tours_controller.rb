class ToursController < ApplicationController
  before_action :set_title_meta_tag

  def index
  end

  def calendar
  end

  def import
  end

  def state
  end

  def contract
  end

  def customer
  end

  private
    def common_title(options={})
      "#{t('controller.name.tours')}#{t("controller.tours.action.#{action_name}")}"
    end
end
