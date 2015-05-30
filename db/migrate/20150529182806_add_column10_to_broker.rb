class AddColumn10ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :check_term_of_use, :boolean
  end
end
