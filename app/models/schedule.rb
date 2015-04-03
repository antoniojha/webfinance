class Schedule < ActiveRecord::Base

  belongs_to :broker
  belongs_to :user

  validates :broker_id, :user_id, presence: true
 # validates_uniqueness_of :time_begin
  
  def hours=(hour)
    @hour_begin=hour.split("-").first
    @hour_end=hour.split("-").last    
  end
  def hours
    if @hour_begin && @hour_end
    @hour_begin +"-"+@hour_end
    end
  end
  def date=(date)
    @date=date
    self.schedule_date=date
  end
  def date
    @date
  end
  before_validation(:on => :create) do
    self.time_begin=DateTime.strptime(@date+@hour_begin,("%Y-%m-%d%H:%M%p"))
    self.time_end=DateTime.strptime(@date+@hour_end,("%Y-%m-%d%H:%M%p"))
  end
end
