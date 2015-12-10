class CreateVectors < ActiveRecord::Migration
  def change
    create_table :vectors do |t|
      t.integer :user_id
      t.integer :subcategory_id
      t.integer :tag_id

      t.timestamps null: false
    end

    add_index :vectors, [ :user_id, :subcategory_id, :tag_id ], unique: true
  end
end
