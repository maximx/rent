class RemovePhoneIndexUniqueOnProfiles < ActiveRecord::Migration
  def change
    remove_index :profiles, :phone
    add_index :profiles, :phone
  end
end
