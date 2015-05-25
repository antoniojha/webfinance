class AddColumn3ToUser < ActiveRecord::Migration
  def change
    add_column :users, :goal, :string
    add_column :users, :income_level, :string
  end
end
