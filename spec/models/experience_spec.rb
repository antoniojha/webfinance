require 'rails_helper'

describe Experience do
  describe "create experience" do
    before do
      @experience=Experience.new(company:"test company",title:"test title", begin_date:Date.today-1,end_date:Date.today)
    end
    subject {@experience}
    it {should respond_to(:company)}
    it {should respond_to(:title)}
    it {should respond_to(:begin_date)}
    it {should respond_to(:end_date)}
    it {should be_valid}
    describe "shouldn't save broker when company is blank" do
      before {@experience.company=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when title is blank" do
      before {@experience.title=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when begin date is blank" do
      before {@experience.begin_date=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when end date is blank" do
      before {@experience.end_date=""}
      it {should_not be_valid}  
    end    
    describe "should save if end date is before begin date" do
      before do
        @experience.end_date=Date.today-1
        @experience.begin_date=Date.today
      end
      it {should_not be_valid}
    end
    describe "should save if it's current experience but does not have end date and begin date" do
      before do
        @experience.current_experience=true
        @experience.end_date=""
        @experience.begin_date=""
      end
      it {should be_valid}
    end
  end
end

