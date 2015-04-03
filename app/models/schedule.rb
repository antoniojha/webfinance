class Schedule < ActiveRecord::Base
  attr_accessor :hours, :date
  belongs_to :broker
  belongs_to :user

  validates :broker_id, :user_id, presence: true
 # validates_uniqueness_of :time_begin
  
  before_validation(:on => :create) do
    @hour_begin=hours.split("-").first
    @hour_end=hours.split("-").last   
    @date=date
    self.schedule_date=date
    self.time_begin=DateTime.strptime(date+@hour_begin,("%Y-%m-%d%H:%M%p"))
    self.time_end=DateTime.strptime(date+@hour_end,("%Y-%m-%d%H:%M%p"))
  end
end
