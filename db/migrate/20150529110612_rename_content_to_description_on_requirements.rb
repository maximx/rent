class RenameContentToDescriptionOnRequirements < ActiveRecord::Migration
  def change
    rename_column :requirements, :content, :description
  end
end
