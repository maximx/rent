class AddSubcategoryIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :subcategory_id, :integer
  end
end
