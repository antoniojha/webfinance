class AddColumnToBroker13 < ActiveRecord::Migration
  def change
    add_column :brokers, :edit_current_step, :string
    rename_column :brokers, :current_step, :register_current_step
  end
end
