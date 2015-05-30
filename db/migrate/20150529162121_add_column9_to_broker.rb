class AddColumn9ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :skills, :text
    add_column :brokers, :ad_statement, :text
  end
end
