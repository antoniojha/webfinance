class FinancialStory < ActiveRecord::Base
  attr_accessor :financial_story_modal
  belongs_to :product
  belongs_to :broker
  has_many :micro_comments
  has_many :financial_goal_story_rels, dependent: :destroy
  has_many :goals, through: :financial_goal_story_rels
  validates :title, :financial_category,:product_id,:description,:broker_id, presence:true
end
