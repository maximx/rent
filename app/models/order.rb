class Order < ActiveRecord::Base
  belongs_to :user, polymorphic: true
end
