class CreateItemsSelections < ActiveRecord::Migration
  def change
    create_table :items_selections do |t|
      t.integer :item_id
      t.integer :selection_id

      t.timestamps null: false
    end
    add_index :items_selections, [ :item_id, :selection_id ], unique: true
  end
end
