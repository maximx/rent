class DropTableOrderRecords < ActiveRecord::Migration
  def change
    drop_table :order_records
  end
end
