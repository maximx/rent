class ChangeUserRefToBorrowerRefOnOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :user_id, :borrower_id
    rename_column :orders, :user_type, :borrower_type
  end
end
