class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items

  # controller_name, action_name 用來判斷來源 controller, action
  def self.grouped_select(controller_name = nil, action_name = nil, user_account = nil)
    is_users = (controller_name == 'users')
    is_items_search = (controller_name == 'items' and action_name == 'search')

    url_helpers = Rails.application.routes.url_helpers

    includes(:subcategories).all.map do |category|
      subcategories = category.subcategories.map do |subcategory|
        href_url = if is_users
                     # 找 user 的自定 tag
                     url_helpers.vectors_user_path(user_account)
                   elsif is_items_search
                     ''
                   else
                     # 找 current_user 的自定 tag 及current_user.item 的 selection
                     url_helpers.account_subcategory_vectors_path(subcategory)
                   end
        [ subcategory.name, subcategory.id, { 'data-href': href_url } ]
      end
      [ category.name, subcategories ]
    end
  end

  def meta_keywords
    I18n.t('rent.keywords') + name.split("、")
  end

  def meta_description
    "探索#{I18n.t('rent.site_name')}中有關#{name}的承租物"
  end
end
