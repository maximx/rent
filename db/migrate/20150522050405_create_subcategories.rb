class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.string :name
      t.integer :category_id
      t.integer :serial

      t.timestamps null: false
    end
  end
end
