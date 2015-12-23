class AddItemNumberToItems < ActiveRecord::Migration
  def change
    add_column :items, :product_id, :string
    add_index :items, [:user_id, :product_id]
  end
end
