class ChangeFreeDaysDefaultOnRecords < ActiveRecord::Migration
  def up
    change_column_default :records, :free_days, nil
  end

  def down
    change_column_default :records, :free_days, 0
  end
end
