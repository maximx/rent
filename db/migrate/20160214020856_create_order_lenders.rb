class CreateOrderLenders < ActiveRecord::Migration
  def change
    create_table :order_lenders do |t|
      t.integer :order_id
      t.integer :lender_id
      t.string :aasm_state
      t.integer :deliver_id

      t.timestamps null: false
    end

    add_index :order_lenders, [:order_id, :lender_id], unique: true
  end
end
