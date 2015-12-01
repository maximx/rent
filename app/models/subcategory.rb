class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :items

  def title
    category.name + '-' + name
  end

  def meta_keywords
    I18n.t('rent.keywords') + [name]
  end

  def meta_description
    "探索#{I18n.t('rent.site_name')}中有關#{name}的承租物"
  end
end
