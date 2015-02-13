class AddColumnToBroker7 < ActiveRecord::Migration
  def change
    add_column :brokers, :submitted_at, :datetime

  end
end
