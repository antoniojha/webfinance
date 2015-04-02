class Schedule < ActiveRecord::Base
  attr_accessor :date, :hours
  belongs_to :broker
  belongs_to :user
  before_validation :create_schedule_times
  validates :broker_id, :user_id, presence: true
  validates_uniqueness_of :time_begin
  
  
  def create_schedule_times

    hour_begin=@hours.split("-").first
    hour_end=@hours.split("-").last
    self.time_begin=DateTime.strptime(@date+hour_begin,("%Y-%m-%d%H:%M%p"))
    self.time_end=DateTime.strptime(@date+hour_end,("%Y-%m-%d%H:%M%p"))
    self.schedule_date=@date
  end
end
