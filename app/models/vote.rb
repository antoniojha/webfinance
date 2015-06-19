class Vote < ActiveRecord::Base
  belongs_to :financial_story
  belongs_to :user
  belongs_to :broker
  validates_uniqueness_of :broker_id, allow_blank:true, scope:[:financial_story_id], message:"You have already voted!"
  validates_uniqueness_of :user_id, allow_blank:true, scope:[:financial_story_id], message:"You have already voted!"
end
