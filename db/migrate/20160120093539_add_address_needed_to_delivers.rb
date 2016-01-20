class AddAddressNeededToDelivers < ActiveRecord::Migration
  def change
    add_column :delivers, :address_needed, :boolean, default: true
  end
end
