class AddFreeDaysOnProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :free_days, :integer, default: 0
  end
end
