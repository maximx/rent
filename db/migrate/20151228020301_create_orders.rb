class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
