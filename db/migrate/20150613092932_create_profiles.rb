class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.string :address
      t.string :phone
      t.text :description

      t.timestamps null: false
    end
  end
end
