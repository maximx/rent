class AddLatitudeToItems < ActiveRecord::Migration
  def change
    add_column :items, :latitude, :float
  end
end
