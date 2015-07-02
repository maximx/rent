class City < ActiveRecord::Base

  def self.options_collection
    self.all.collect { |c| [c.name, c.name]}
  end

end
