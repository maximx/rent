class DropTableItemDelivers < ActiveRecord::Migration
  def change
    drop_table :item_delivers
  end
end
