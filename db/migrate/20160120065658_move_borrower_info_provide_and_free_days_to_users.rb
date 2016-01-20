class MoveBorrowerInfoProvideAndFreeDaysToUsers < ActiveRecord::Migration
  def up
    add_column :users, :borrower_info_provide, :boolean, default: false
    remove_column :profiles, :borrower_info_provide

    add_column :users, :free_days, :integer, default: 0
    remove_column :profiles, :free_days
  end

  def down
    remove_column :users, :borrower_info_provide
    add_column :profiles, :borrower_info_provide, :boolean, default: false

    remove_column :users, :free_days
    add_column :profiles, :free_days, :integer, default: 0
  end
end
