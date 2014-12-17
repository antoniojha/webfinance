require 'rails_helper'

RSpec.describe Spending, :type => :model do
  describe Spending do
    before{
      @spending=FactoryGirl.build(:spending)
      #since the above code will result with picture_content_type=application/octet-stream
      #manually set the picture_content_type below to ensure test passes.
 #     @spending.picture_content_type="image/jpg"
    }
    subject{@spending}
    describe "test for a valid spending" do
      it{should respond_to(:category)}
      it{should respond_to(:transaction_date)}
      it{should respond_to(:amount)}
      it{should respond_to(:description)}
      it{should respond_to(:picture_file_name)}
      it{should respond_to(:picture_content_type)}
      it{should respond_to(:picture_file_size)}
      it{should be_valid}
    end
    describe "test virtual attribute transaction date string" do
      before do
        @spending.transaction_date_string="tomorrow"
        @spending.save!
      end
      let(:date){Date.tomorrow}
      #check
      it "chronic gem should work" do
        expect(@spending.transaction_date.strftime('%F')).to eq (date.strftime('%Y-%m-%d'))
      end
    end
    #check
    describe "should be invalid when description is not entered" do
      before {@spending.description=""}
      it {should_not be_valid}
    end
    #check
    describe "should be invalid when transaction date is not entered" do
      before {@spending.transaction_date=""}
      it {should_not be_valid}
    end
    #check
    describe "should be invalid when transaction date is not valid" do
      before {@spending.transaction_date_string="12/32/14"}
      it {should_not be_valid}
    end
    #check
    describe "should be invalid when category is not entered" do
      before {@spending.category=""}
      it {should_not be_valid}
    end
    #check
    describe "should be invalid when amount is not entered" do
      before {@spending.amount=""}
      it {should_not be_valid}
    end
    #check
    describe "should be invalid when uploaded file format is incorrect" do
      before {@spending.picture=(Rails.root+"spec/fixtures/images/test.html").open}
      it {should_not be_valid}
    end
    it "should round amount to the second decimal digit" do
      @spending.amount=100.195
      @spending.save!
      expect(@spending.amount).to eq 100.20
    end
  end
end
