class RemoveEmailFromRequirements < ActiveRecord::Migration
  def change
    remove_column :requirements, :email, :string
  end
end
