class Requirement < ActiveRecord::Base
  validates_presence_of :name, :content
  belongs_to :demander
end
