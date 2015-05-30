class AddColumn1ToLicense < ActiveRecord::Migration
  def change
    add_reference :licenses, :setup_broker, index: true
  end
end
