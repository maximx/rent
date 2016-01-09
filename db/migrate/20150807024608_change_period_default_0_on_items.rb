class ChangePeriodDefault0OnItems < ActiveRecord::Migration
  def change
    change_column :items, :period, :integer, default: 0
  end
end
