class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.integer :vector_id
      t.integer :tag_id

      t.timestamps null: false
    end
    add_index :selections, [ :vector_id, :tag_id ], unique: true
  end
end
