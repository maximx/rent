class AddLineFacebookToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :line, :string
    add_column :profiles, :facebook, :string
  end
end
