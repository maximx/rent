class AddUserTypeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :user_type, :string
    add_index :profiles, [ :user_id, :user_type ]
  end
end
