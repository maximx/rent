class AddOrderLenderIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :order_lender_id, :integer
    add_index :records, :order_lender_id
  end
end
