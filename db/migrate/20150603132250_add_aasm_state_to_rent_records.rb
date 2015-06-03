class AddAasmStateToRentRecords < ActiveRecord::Migration
  def change
    add_column :rent_records, :aasm_state, :string
  end
end
