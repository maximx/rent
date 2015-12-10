class AddIndexToItemCollections < ActiveRecord::Migration
  def change
    add_index :item_collections, [ :user_id, :item_id ], unique: true
  end
end
