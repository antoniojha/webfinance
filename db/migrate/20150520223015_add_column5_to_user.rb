class AddColumn5ToUser < ActiveRecord::Migration
  def change
    add_column :users, :occupation, :string
  end
end
