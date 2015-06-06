class AddColumn2ToBrokerRequest < ActiveRecord::Migration
  def change
    add_column :broker_requests, :complement, :boolean
    add_column :broker_requests, :comment, :text
  end
end
