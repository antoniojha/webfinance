class CreateBrokerRequests < ActiveRecord::Migration
  def change
    create_table :broker_requests do |t|
      t.string :type
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
