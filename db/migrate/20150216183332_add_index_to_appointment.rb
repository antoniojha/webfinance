class AddIndexToAppointment < ActiveRecord::Migration
  def change
    add_index :appointments, [:broker_id, :product_id], unique: true
  end
end
