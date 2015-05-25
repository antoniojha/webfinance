class AddColumn2ToUser < ActiveRecord::Migration
  def change
    add_column :users, :step, :string
  end
end
