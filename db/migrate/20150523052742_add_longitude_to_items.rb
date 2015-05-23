class AddLongitudeToItems < ActiveRecord::Migration
  def change
    add_column :items, :longitude, :float
  end
end
