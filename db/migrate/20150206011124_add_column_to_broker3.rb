class AddColumnToBroker3 < ActiveRecord::Migration
  def change
    add_column :brokers, :approved, :boolean, default:false
    add_column :brokers, :username, :string
  end
end
