class AddColumn7ToUser < ActiveRecord::Migration
  def change
    add_column :users, :about_statement, :text
    add_column :users, :satisfaction, :string
  end
end
