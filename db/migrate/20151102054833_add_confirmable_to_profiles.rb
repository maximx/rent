class AddConfirmableToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :confirmation_token,   :string
    add_column :profiles, :confirmed_at,         :datetime
    add_column :profiles, :confirmation_sent_at, :datetime
  end
end
