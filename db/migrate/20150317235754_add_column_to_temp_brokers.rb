class AddColumnToTempBrokers < ActiveRecord::Migration
  def change
    add_column :temp_brokers, :change_approved?, :boolean, default:false
  end
end
