class AddColumnToBroker6 < ActiveRecord::Migration
  def change
    add_column :brokers, :confirmation_number, :string
  end
end
