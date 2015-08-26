class CreateRentRecordStateLogs < ActiveRecord::Migration
  def change
    create_table :rent_record_state_logs do |t|
      t.integer :rent_record_id
      t.string :aasm_state

      t.timestamps null: false
    end
  end
end
