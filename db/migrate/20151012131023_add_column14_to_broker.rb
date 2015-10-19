class AddColumn14ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :current_experience_id, :integer
  end
end
