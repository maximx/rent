class Customer < ActiveRecord::Base
  has_one :profile
end
