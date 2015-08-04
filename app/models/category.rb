class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items

  def meta_keywords
    Rent::KEYWORDS + name.split("、")
  end

  def meta_description
    "探索#{Rent::SITE_NAME}中有關#{name}的承租物"
  end
end
