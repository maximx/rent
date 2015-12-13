class AddUserIdToSelections < ActiveRecord::Migration
  def change
    add_column :selections, :user_id, :integer
  end
end
