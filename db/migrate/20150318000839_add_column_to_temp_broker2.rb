class AddColumnToTempBroker2 < ActiveRecord::Migration
  def change
    add_column :temp_brokers, :license_type_edit, :string
    add_column :temp_brokers, :license_type_remove, :string
    add_column :temp_brokers, :edit_type, :integer
  end
end
