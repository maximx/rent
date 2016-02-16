class CreateOrderLenderLogs < ActiveRecord::Migration
  def change
    create_table :order_lender_logs do |t|
      t.integer :order_lender_id
      t.string :aasm_state
      t.references :user, polymorphic: true
      t.string :info

      t.timestamps null: false
    end
    add_index :order_lender_logs, :order_lender_id
  end
end
