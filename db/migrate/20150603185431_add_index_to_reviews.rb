class AddIndexToReviews < ActiveRecord::Migration
  def change
    add_index :reviews, [ :rent_record_id, :judger_id, :user_id ], unique: true
  end
end
