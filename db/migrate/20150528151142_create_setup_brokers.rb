class CreateSetupBrokers < ActiveRecord::Migration
  def change
    create_table :setup_brokers do |t|

      t.timestamps
    end
  end
end
