class Follow < ActiveRecord::Base
  validates_presence_of :follower_id, :followed_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
