class AddColumnToFinancialGoalStoryRel < ActiveRecord::Migration
  def change
    add_column :financial_goal_story_rels, :summary, :string
  end
end
