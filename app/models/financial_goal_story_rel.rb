class FinancialGoalStoryRel < ActiveRecord::Base
  belongs_to :goal
  belongs_to :financial_story
end
