class Schedule < ActiveRecord::Base
  belongs_to :broker
  belongs_to :user

#  validates :broker_id, :user_id, presence: true
  validates_uniqueness_of :time_begin, scope:[:schedule_date,:broker_id]
  def hours=(hour)
    self.time_begin=hour.split("-").first
    self.time_end=hour.split("-").last      
  end
  def hours

  end
  # self.time_begin=DateTime.strptime(date+@hour_begin,("%Y-%m-%d%H:%M%p"))
end
