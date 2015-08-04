class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :items

  def title
    category.name + '-' + name
  end

  def meta_keywords
    Rent::KEYWORDS + [name]
  end

  def meta_description
    "探索#{Rent::SITE_NAME}中有關#{name}的承租物"
  end
end
