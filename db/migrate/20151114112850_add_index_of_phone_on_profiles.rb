class AddIndexOfPhoneOnProfiles < ActiveRecord::Migration
  def change
    add_index :profiles, :phone, unique: true
  end
end
