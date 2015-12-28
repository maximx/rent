class CreateOrderRecords < ActiveRecord::Migration
  def change
    create_table :order_records do |t|
      t.integer :order_id
      t.integer :record_id

      t.timestamps null: false
    end
    add_index :order_records, :order_id
  end
end
