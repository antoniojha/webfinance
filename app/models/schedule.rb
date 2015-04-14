class Schedule < ActiveRecord::Base
  belongs_to :broker
  belongs_to :user
  attr_accessor :hours,:date
  validates :broker_id, :user_id, presence: true
  validates_uniqueness_of :time_begin, scope:[:schedule_date,:broker_id]
  before_validation(:on => :create) do

    hour_begin=hours.split("-").first
    hour_end=hours.split("-").last     
    self.schedule_date=date
    self.time_begin=DateTime.parse(date+hour_begin).utc
    self.time_end=DateTime.parse(date+hour_end).utc
  end

  # self.time_begin=DateTime.strptime(date+@hour_begin,("%Y-%m-%d%H:%M%p"))
end
