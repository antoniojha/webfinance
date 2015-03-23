require 'rails_helper'

describe Appointment do
  before do 
    @appointment=Appointment.new(broker_id:1, product_id:2)
  end
  subject {@appointment}
  it {should respond_to(:broker_id)}
  it {should respond_to(:product_id)}
  it {should be_valid}
  describe "should require a broker id" do
    before{@appointment.broker_id=nil}
    it {should_not be_valid}
  end
  describe "should require a product id" do
    before{@appointment.product_id=nil}
    it {should_not be_valid}  
  end
  
end