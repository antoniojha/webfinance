class FinancialStory < ActiveRecord::Base
  belongs_to :product
  belongs_to :broker
end
