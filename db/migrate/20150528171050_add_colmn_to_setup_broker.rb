class AddColmnToSetupBroker < ActiveRecord::Migration
  def change
    add_reference :setup_brokers, :broker, index: true
  end
end
