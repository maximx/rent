class Item < ActiveRecord::Base
  belongs_to :render, class_name: :User, foreign_key: :user_id

  enum period: [ :時, :日, :月, :年 ]

  def editable_by?(user)
    user && user == render
  end
end
