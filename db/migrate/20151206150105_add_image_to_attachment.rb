class AddImageToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :image, :string
  end
end
