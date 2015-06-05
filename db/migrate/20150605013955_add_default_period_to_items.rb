class AddDefaultPeriodToItems < ActiveRecord::Migration
  def change
    change_column :items, :period, :integer, default: 1
  end
end
