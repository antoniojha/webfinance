class CreateBrokerSearches < ActiveRecord::Migration
  def change
    create_table :broker_searches do |t|
      t.string :name
      t.string :license_types
      t.string :city
      t.string :state
      t.decimal :distance_away

      t.timestamps
    end
  end
end
