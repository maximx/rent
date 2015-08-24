class AddCityIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :city_id, :integer
  end
end
