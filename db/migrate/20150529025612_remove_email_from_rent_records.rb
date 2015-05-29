class RemoveEmailFromRentRecords < ActiveRecord::Migration
  def change
    remove_column :rent_records, :email, :string
  end
end
