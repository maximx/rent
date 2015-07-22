class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :items

  def meta_keywords
    KEYWORDS + name.split("、")
  end
end
