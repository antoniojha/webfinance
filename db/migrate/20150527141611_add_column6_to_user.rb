class AddColumn6ToUser < ActiveRecord::Migration
  def change
    add_column :users, :age_level, :string
  end
end
