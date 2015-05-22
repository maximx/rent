class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :item_id
      t.text :content
      t.integer :user_id
      t.text :reply

      t.timestamps null: false
    end
  end
end
