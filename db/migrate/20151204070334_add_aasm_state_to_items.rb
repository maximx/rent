class AddAasmStateToItems < ActiveRecord::Migration
  def change
    add_column :items, :aasm_state, :string
  end
end
