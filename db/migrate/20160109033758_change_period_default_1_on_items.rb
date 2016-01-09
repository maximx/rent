class ChangePeriodDefault1OnItems < ActiveRecord::Migration
  def up
    change_column_default :items, :period, 1
  end

  def down
    change_column_default :items, :period, 0
  end
end
