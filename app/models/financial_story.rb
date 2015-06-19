class FinancialStory < ActiveRecord::Base
  belongs_to :product
  belongs_to :broker
  has_many :micro_comments
end
