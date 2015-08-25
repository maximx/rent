class AddDeliverIdToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :deliver_id, :integer
  end
end
