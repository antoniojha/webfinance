class AddColumn1ToFinancialStory < ActiveRecord::Migration
  def change
    add_column :financial_stories, :votes, :integer, default:0
  end
end
