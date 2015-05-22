class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.float :price
      t.integer :period
      t.string :address
      t.float :deposit
      t.text :description

      t.timestamps null: false
    end
  end
end
