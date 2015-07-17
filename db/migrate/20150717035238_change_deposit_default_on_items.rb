class ChangeDepositDefaultOnItems < ActiveRecord::Migration
  def up
    change_column_default :items, :deposit, 0
  end

  def down
    change_column_default :items, :deposit, nil
  end
end
