class RemoveNameAndPhoneFromRentRecords < ActiveRecord::Migration
  def change
    remove_column :rent_records, :name, :string
    remove_column :rent_records, :phone, :string
  end
end
