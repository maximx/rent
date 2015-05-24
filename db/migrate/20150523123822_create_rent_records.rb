class CreateRentRecords < ActiveRecord::Migration
  def change
    create_table :rent_records do |t|
      t.integer :item_id
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :phone
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
