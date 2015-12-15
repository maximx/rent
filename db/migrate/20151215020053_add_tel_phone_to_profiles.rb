class AddTelPhoneToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :tel_phone, :string
    add_index :profiles, :phone
  end
end
