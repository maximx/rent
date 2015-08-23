class AddBankAccountToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :bank_code, :string
    add_column :profiles, :bank_account, :string
  end
end
