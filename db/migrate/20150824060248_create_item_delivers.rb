class CreateItemDelivers < ActiveRecord::Migration
  def change
    create_table :item_delivers do |t|
      t.integer :item_id
      t.integer :deliver_id

      t.timestamps null: false
    end

    add_index :item_delivers, [ :item_id, :deliver_id ], unique: true
  end
end
