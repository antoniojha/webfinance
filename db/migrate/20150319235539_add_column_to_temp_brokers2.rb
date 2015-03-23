class AddColumnToTempBrokers2 < ActiveRecord::Migration
  def change
    add_column :temp_brokers, :work_ext, :string
    add_column :temp_brokers, :web, :string
  end
end
