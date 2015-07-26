class MicroComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :broker
  belongs_to :financial_story
  belongs_to :financial_testimony
  has_many :activities, as: :trackable, dependent: :destroy
end
