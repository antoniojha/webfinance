class FinancialStory < ActiveRecord::Base
  attr_accessor :financial_story_modal
  belongs_to :product
  belongs_to :broker
  has_many :micro_comments
  validates :title, :financial_category,:product_id,:description,:broker_id, presence:true
end
