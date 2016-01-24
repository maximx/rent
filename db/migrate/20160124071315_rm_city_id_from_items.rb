class RmCityIdFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :city_id, :integer
  end
end
