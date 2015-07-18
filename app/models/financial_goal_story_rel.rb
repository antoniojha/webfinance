class FinancialGoalStoryRel < ActiveRecord::Base
  belongs_to :goal
  belongs_to :financial_story
  validates :summary, length: { maximum: 200 }
  validates_uniqueness_of :goal_id, :scope=> :financial_story_id
end
