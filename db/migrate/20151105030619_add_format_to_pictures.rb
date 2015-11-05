class AddFormatToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :format, :string
  end
end
