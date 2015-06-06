class ChangeBrokerRequestColumn < ActiveRecord::Migration
  def change
    rename_column :broker_requests, :type, :request_type
  end
end
