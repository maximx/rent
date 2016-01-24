class RmAddressLatitudeLongitudeFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :address, :integer
    remove_column :items, :latitude, :float
    remove_column :items, :longitude, :float
  end
end
