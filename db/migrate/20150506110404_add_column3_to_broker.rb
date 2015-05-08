class AddColumn3ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :email_confirmation_token, :string
    add_column :brokers, :email_confirmation_sent_at, :string
  end
end
