class Schedule < ActiveRecord::Base
  belongs_to :broker
  belongs_to :user
end
