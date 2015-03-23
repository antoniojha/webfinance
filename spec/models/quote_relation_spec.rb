require 'rails_helper'

describe QuoteRelation do
 
  before do 
    @relation=QuoteRelation.new(user_id:1, broker_id:2, product_type:1)
  end
  subject {@relation}
  it {should respond_to(:user_id)}
  it {should respond_to(:broker_id)}
  it {should respond_to(:product_type)}
  it {should be_valid}
  describe "should require a user id" do
    before{@relation.user_id=nil}
    it {should_not be_valid}
  end
  describe "should require a broker id" do
    before{@relation.broker_id=nil}
    it {should_not be_valid}  
  end
  describe "should require a product type" do
    before{@relation.product_type=nil}
    it {should_not be_valid}
  end
  
end
