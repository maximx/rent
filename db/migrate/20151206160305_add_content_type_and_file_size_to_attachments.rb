class AddContentTypeAndFileSizeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :file_size, :integer, limit: 8
    add_column :attachments, :content_type, :string
  end
end
