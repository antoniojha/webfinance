class AddColumn2ToVote < ActiveRecord::Migration
  def change
    add_reference :votes, :financial_testimony, index: true
  end
end
