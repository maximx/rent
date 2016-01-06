class AddFreeDaysOnRecords < ActiveRecord::Migration
  def change
    add_column :records, :free_days, :integer, default: 0
  end
end
