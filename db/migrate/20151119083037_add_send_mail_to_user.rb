class AddSendMailToUser < ActiveRecord::Migration
  def change
    add_column :profiles, :send_mail, :boolean, default: true
  end
end
