class RemoveCityIdFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :city_id, :integer
  end
end
