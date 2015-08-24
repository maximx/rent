class City < ActiveRecord::Base
  has_many :items

  def self.options_collection
    self.all.collect { |c| [c.name, c.id]}
  end
end
