class RemoveFirm < ActiveRecord::Migration
  def change
    drop_table :firms
  end
end
