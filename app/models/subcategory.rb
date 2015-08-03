class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :items

  def meta_keywords
    Rent::KEYWORDS + [name]
  end

  def title
    category.name + "-" + name
  end
end
