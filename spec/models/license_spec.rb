require 'rails_helper'

describe License do
  describe "create license" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    before do
      @license=License.new(license_type:"Life Insurance License", license_number:"test", expiration_date:Date.today, broker_id:broker.id)
      @license.license_image=(Rails.root+"spec/fixtures/test_files/example_license.pdf").open
    end
    subject {@license}
    it {should respond_to(:broker_id)}
    it {should respond_to(:license_type)}
    it {should respond_to(:license_number)}
    it {should respond_to(:expiration_date)}
    it {should respond_to(:license_image)}
    it {should be_valid}
    describe "when broker_id is blank" do
      before{@license.broker_id=nil}
      it {should_not be_valid}
    end  
    describe "when license_type is blank" do
      before{@license.license_type=nil}
      it {should_not be_valid}
    end
    describe "when license_number is blank" do
      before{@license.license_number=nil}
      it {should_not be_valid}
    end    
    describe "when expiration_date is blank" do
      before{@license.expiration_date=nil}
      it {should_not be_valid}
    end    
    describe "when license_image is blank" do
      #coulnt' get it to work
    end      
    describe "when license_type is the same by the same broker" do
      before do
        @other_license=License.new(license_type:@license.license_type, license_number:"other", expiration_date:Date.today, broker_id:broker.id)
        @other_license.license_image=(Rails.root+"spec/fixtures/test_files/example_license.pdf").open
        @other_license.save
      end
      it {should_not be_valid}
    end
  end
  describe "test dependencies" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    before do
      @license=License.new(license_type:"type", license_number:"test", expiration_date:Date.today, broker_id:broker.id)
      @license.license_image=(Rails.root+"spec/fixtures/test_files/example_license.pdf").open
    end
    describe "broker_request" do
      before do
        broker_request=@license.build_broker_request
        broker_request.save(validate:false)
      end
      it "should have one broker_request" do
        expect(BrokerRequest.count).to eq 1
      end
      it "should remove broker_request" do
        @license.destroy
        expect(BrokerRequest.count).to eq 0   
      end
    end    
  end
end
