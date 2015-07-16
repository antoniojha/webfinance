class Goal < ActiveRecord::Base
  belongs_to :user
  validates :description, presence: true
  has_many :financial_goal_story_rels, dependent: :destroy
  has_many :financial_stories, through: :financial_goal_story_rels
end
