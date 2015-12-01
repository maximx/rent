class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items

  def meta_keywords
    I18n.t('rent.keywords') + name.split("、")
  end

  def meta_description
    "探索#{I18n.t('rent.site_name')}中有關#{name}的承租物"
  end
end
