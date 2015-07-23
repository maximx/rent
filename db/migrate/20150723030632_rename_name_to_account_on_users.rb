class RenameNameToAccountOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :name, :account
  end
end
