require 'rails_helper'

describe Education do
  describe "create education" do
    before do
      @education=Education.new(school:"test school",degree:"test degree", begin_date:Date.today-1,end_date:Date.today)
    end
    subject {@education}
    it {should respond_to(:school)}
    it {should respond_to(:degree)}
    it {should respond_to(:begin_date)}
    it {should respond_to(:end_date)}
    it {should be_valid}
    describe "shouldn't save broker when school is blank" do
      before {@education.school=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when degree is blank" do
      before {@education.degree=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when begin date is blank" do
      before {@education.begin_date=""}
      it {should_not be_valid}  
    end
    describe "shouldn't save broker when end date is blank" do
      before {@education.end_date=""}
      it {should_not be_valid}  
    end    
    describe "should save if end date is before begin date" do
      before do
        @education.end_date=Date.today-1
        @education.begin_date=Date.today
      end
      it {should_not be_valid}
    end
  end
end
