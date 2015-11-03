class AddDeliverFeeToItems < ActiveRecord::Migration
  def change
    add_column :items, :deliver_fee, :float, default: 0
  end
end
