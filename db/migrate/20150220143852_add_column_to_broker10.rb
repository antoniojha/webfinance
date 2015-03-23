class AddColumnToBroker10 < ActiveRecord::Migration
  def change
    add_column :brokers, :current_step, :string
  end
end
