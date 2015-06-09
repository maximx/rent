class ChangeRateDefaultOnReviews < ActiveRecord::Migration
  def change
    change_column :reviews, :rate, :integer, default: 2
  end
end
