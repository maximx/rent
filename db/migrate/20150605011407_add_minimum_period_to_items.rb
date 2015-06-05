class AddMinimumPeriodToItems < ActiveRecord::Migration
  def change
    add_column :items, :minimum_period, :integer, default: 1
  end
end
