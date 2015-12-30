class AddOrderIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :order_id, :integer
    add_index :records, :order_id
  end
end
