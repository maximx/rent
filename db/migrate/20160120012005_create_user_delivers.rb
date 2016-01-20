class CreateUserDelivers < ActiveRecord::Migration
  def change
    create_table :user_delivers do |t|
      t.integer :user_id
      t.integer :deliver_id
    end
  end
end
