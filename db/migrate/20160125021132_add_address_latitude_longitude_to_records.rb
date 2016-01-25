class AddAddressLatitudeLongitudeToRecords < ActiveRecord::Migration
  def change
    add_column :records, :address, :string
    add_column :records, :latitude, :float
    add_column :records, :longitude, :float
  end
end
