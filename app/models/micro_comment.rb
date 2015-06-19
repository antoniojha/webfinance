class MicroComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :broker
  belongs_to :financial_story
end
