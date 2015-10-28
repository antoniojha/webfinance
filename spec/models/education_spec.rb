require 'rails_helper'

describe Education do
  describe "create education" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    before do
      @education=Education.new(school:"test school",degree:"test degree", begin_date:Date.today-1,end_date:Date.today, broker_id:broker.id)
    end
    subject {@education}
    it {should respond_to(:school)}
    it {should respond_to(:degree)}
    it {should respond_to(:begin_date)}
    it {should respond_to(:end_date)}
    it {should respond_to(:broker_id)}
    it {should be_valid}
    describe "when broker_id is not present" do
      before{@education.broker_id=nil}
      it {should_not be_valid}
    end
    describe "when school is blank" do
      before {@education.school=""}
      it {should_not be_valid}  
    end
    describe "when degree is blank" do
      before {@education.degree=""}
      it {should_not be_valid}  
    end
    describe "when begin date is blank" do
      before {@education.begin_date=""}
      it {should_not be_valid}  
    end
    describe " when end date is blank" do
      before {@education.end_date=""}
      it {should_not be_valid}  
    end    
    describe "if end date is before begin date" do
      before do
        @education.end_date=Date.today-1
        @education.begin_date=Date.today
      end
      it {should_not be_valid}
    end
  end
end
