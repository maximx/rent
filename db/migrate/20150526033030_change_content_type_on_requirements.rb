class ChangeContentTypeOnRequirements < ActiveRecord::Migration
  def change
    change_column :requirements, :content, :text
  end
end
