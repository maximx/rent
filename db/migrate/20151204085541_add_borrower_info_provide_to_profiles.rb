class AddBorrowerInfoProvideToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :borrower_info_provide, :boolean, default: false
  end
end
