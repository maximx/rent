class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end

    add_index :banks, :code, unique: true
  end
end
