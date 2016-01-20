class AddRemitDeliveryToDelivers < ActiveRecord::Migration
  def change
    add_column :delivers, :remit_needed, :boolean, default: false
    add_column :delivers, :delivery_needed, :boolean, default: false
  end
end
