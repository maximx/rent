class AddHiddenFlagToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :hidden_flag, :boolean, default: false
  end
end
