require 'rails_helper'

describe Experience do
  describe "create experience" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    before do
      @experience=Experience.new(company:"test company",title:"test title", begin_date:Date.today-1,end_date:Date.today, broker_id:broker.id)
    end
    subject {@experience}
    it {should respond_to(:company)}
    it {should respond_to(:title)}
    it {should respond_to(:begin_date)}
    it {should respond_to(:end_date)}
    it {should respond_to(:broker_id)}
    it {should be_valid}
    describe "when broker_id is not present" do
      before{@experience.broker_id=nil}
      it {should_not be_valid}
    end
    describe "when company is blank" do
      before {@experience.company=""}
      it {should_not be_valid}  
    end
    describe "when title is blank" do
      before {@experience.title=""}
      it {should_not be_valid}  
    end
    describe "when begin date is blank" do
      before {@experience.begin_date=""}
      it {should_not be_valid}  
    end
    describe "when end date is blank" do
      before {@experience.end_date=""}
      it {should_not be_valid}  
    end    
    describe "if end date is before begin date" do
      before do
        @experience.end_date=Date.today-1
        @experience.begin_date=Date.today
      end
      it {should_not be_valid}
    end
    describe "if it's current experience but does not have end date and begin date" do
      before do
        @experience.current_experience=true
        @experience.end_date=""
        @experience.begin_date=""
      end
      it {should be_valid}
    end
  end

end

