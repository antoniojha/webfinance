class AddColumnToBroker9 < ActiveRecord::Migration
  def change
    add_reference :brokers, :firm, index: true
  end
end
