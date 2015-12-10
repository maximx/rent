class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items

  def self.grouped_select
    includes(:subcategories).all.map do |c|
      subcategories = c.subcategories.map do |s|
        [
          s.name,
          s.id,
          { 'data-href': Rails.application.routes.url_helpers.account_subcategory_vectors_path(s) }
        ]
      end
      [ c.name, subcategories ]
    end
  end

  def meta_keywords
    I18n.t('rent.keywords') + name.split("、")
  end

  def meta_description
    "探索#{I18n.t('rent.site_name')}中有關#{name}的承租物"
  end
end
