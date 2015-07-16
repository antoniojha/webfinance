class CreateFinancialGoalStoryRels < ActiveRecord::Migration
  def change
    create_table :financial_goal_story_rels do |t|
      t.belongs_to :goal, index: true
      t.belongs_to :financial_story, index: true

      t.timestamps
    end
  end
end
