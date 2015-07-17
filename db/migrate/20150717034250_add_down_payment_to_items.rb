class AddDownPaymentToItems < ActiveRecord::Migration
  def change
    add_column :items, :down_payment, :float, default: 0
  end
end
