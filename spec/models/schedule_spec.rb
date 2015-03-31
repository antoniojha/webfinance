require 'rails_helper'

describe Schedule do
 
  before do 
    @schedule=Schedule.new(user_id:1, broker_id:2, time_begin:Time.now,time_end:Time.now+2.hours,duration:2)
  end
  subject {@schedule}
  it {should respond_to(:user_id)}
  it {should respond_to(:broker_id)}
  it {should respond_to(:time_begin)}
  it {should respond_to(:time_end)}
  it {should respond_to(:duration)}
  it {should be_valid}
  describe "should require a user id" do
    before{@schedule.user_id=nil}
    it {should_not be_valid}
  end
  describe "should require a broker id" do
    before{@schedule.broker_id=nil}
    it {should_not be_valid}  
  end
  
end
