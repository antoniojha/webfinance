class AddColumnToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :provider, :string
    add_column :brokers, :uid, :string
  end
end
