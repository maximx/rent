class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :name
      t.string :content
      t.string :email
      t.string :phone
      t.string :address
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :user_id
      t.float :price

      t.timestamps null: false
    end
  end
end
