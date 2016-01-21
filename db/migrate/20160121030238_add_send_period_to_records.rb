class AddSendPeriodToRecords < ActiveRecord::Migration
  def change
    add_column :records, :send_period, :integer
  end
end
