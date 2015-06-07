class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :imageable, index: true, polymorphic: true
      t.string :public_id
      t.string :name

      t.timestamps null: false
    end
  end
end
