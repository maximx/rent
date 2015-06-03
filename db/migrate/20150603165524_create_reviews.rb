class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rent_record_id
      t.integer :judger_id
      t.integer :user_id
      t.integer :user_role
      t.text :content
      t.integer :rate

      t.timestamps null: false
    end
  end
end
