class UserDeliver < ActiveRecord::Base
  belongs_to :user
  belongs_to :deliver
end
