class AddColumn1ToVote < ActiveRecord::Migration
  def change
    add_column :votes, :description, :string
  end
end
