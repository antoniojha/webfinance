class AddColumn4ToUser < ActiveRecord::Migration
  def change
    add_column :users, :setup_completed?, :boolean, defaults:false
  end
end
