require 'rails_helper'

describe Broker do
  describe "Create Broker" do
    before do
      @broker=Broker.new(first_name:"Broker First Name", last_name:"Broker Last Name", email:"example@example.com",institution_name:"World Financial Group", street:"39-07 Prince St, Suite 6A-3",city:"Flushing",state:"NY",phone_work_1:"718",phone_work_2:"753",phone_work_3:"2309",username:"testing",password: "6004Aj?", password_confirmation:"6004Aj?",license_type:["1","2"])
    end
    subject {@broker}
    it {should respond_to(:first_name)}
    it {should respond_to(:last_name)}
    it {should respond_to(:email)}
    it {should respond_to(:institution_name)}
    it {should respond_to(:street)}
    it {should respond_to(:city)}
    it {should respond_to(:state)}
    it {should respond_to(:phone_number_work)}
    it {should respond_to(:phone_number_cell)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {should respond_to(:confirmation_number_digest)}
    it {should respond_to(:name_or_email)}
    it {should be_valid}
    describe "shouldn't save when first name is not entered" do
      before {@broker.first_name=""}
      it {should_not be_valid}
    end
    describe "shouldn't save when last name is not entered" do
      before {@broker.last_name=""}
      it {should_not be_valid}
    end
    describe "shouldn't save when email is not entered" do
      before {@broker.email=""}
      it {should_not be_valid}
    end 
    describe "shouldn't save when institution name is not entered" do
      before {@broker.institution_name=""}
      it {should_not be_valid}
    end   
    describe "shouldn't save when street is not entered" do
      before {@broker.street=""}
      it {should_not be_valid}
    end 
    describe "shouldn't save when city is not entered" do
      before {@broker.city=""}
      it {should_not be_valid}
    end   
    describe "shouldn't save when state is not entered" do
      before {@broker.state=""}
      it {should_not be_valid}
    end   
    describe "shouldn't save when phone number(work) is not entered" do
      before do
        @broker.phone_work_1=""
        @broker.phone_work_2=""
        @broker.phone_work_3=""
      end
      it {should_not be_valid}
    end 
    describe "when email format is valid" do
      it "should be valid" do
        addresses=%w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @broker.email=valid_address
          expect(@broker).to be_valid
        end
      end
    end
    describe "when email format is invalid" do
      it "should be invalid" do
        addresses=%w[user.foo,com user_at_foo.org example.user@foo. foo@bar_baz.com  foo@baz+baz.com]
        addresses.each do |invalid_address|
          @broker.email=invalid_address
          expect(@broker).not_to be_valid
        end
      end
    end
    describe "when password format is invalid" do
      it "should be invalid" do
        passwords=%w[aaaaaa1 aaaaaaA AAAAAA1]
        passwords.each do |invalid_address|
          @broker.password=invalid_address
          @broker.password_confirmation=invalid_address
          expect(@broker).not_to be_valid
        end
      end
    end 
    describe "when password is too long" do
      before do
        @broker.password="A!1"+"a"*40
        @broker.password_confirmation=@broker.password
      end
      it "should not be valid" do
        expect(@broker).not_to be_valid
      end
    end

    describe "when password is too short" do
      before do
        @broker.password="A!1a"
        @broker.password_confirmation=@broker.password
      end
      it "should not be valid" do
        expect(@broker).not_to be_valid
      end
    end
    # this may or may not failed depending on Geocode query limit
    describe "when work address is entered" do
      it "should register latitude and longitude" do
        @broker.save
        @broker.reload
        expect(@broker.longitude).to be_present
        expect(@broker.latitude).to be_present
      end
    end
    describe "when work phone number is not 10 digit" do
      before do
        @broker.phone_work_1="9"*2
        @broker.phone_work_2="9"*3
        @broker.phone_work_3="9"*3
      end
      it "should not be valid" do
        expect(@broker).not_to be_valid
      end
    end
    describe "when cell phone number is not 10 digit" do
      before do
        @broker.phone_cell_1="9"*2
        @broker.phone_cell_2="9"*3
        @broker.phone_cell_3="9"*3
      end
      it "should not be valid" do
        expect(@broker).not_to be_valid
      end
    end
    describe "when individual parts of phone number is entered" do
      before do
        @broker.phone_cell_1="111"
        @broker.phone_cell_2="222"
        @broker.phone_cell_3="3333"
        @broker.save
      end
      it "should combine them and save it as a whole" do
        expect(@broker.phone_number_cell).to eq "1112223333"
      end
    end
    describe "shouldn't save broker username is already registered" do
      before do
        @broker_with_same_username=@broker.dup
        @broker_with_same_username.save
      end
      it {should_not be_valid} 
      it "should not be valid even if username has differenct case" do
        @broker.username=@broker.username.capitalize
        expect(@broker).not_to be_valid
      end
    end
    describe "shouldn't save broker email is already registered" do
      before do
        @broker_with_same_email=@broker.dup
        @broker_with_same_email.save
      end
      it {should_not be_valid} 
      it "should not be valid even if username has differenct case" do
        @broker.email=@broker.email.capitalize
        expect(@broker).not_to be_valid
      end
    end
    describe "when submit" do
      before do
        @broker.submit
      end
      it "should generate, save confirmation_number" do
        expect(@broker.confirmation_number).to be_present

      end
      it "should send email to broker" do
        expect(last_email.to).to include (@broker.email)
      end
      it "should update submitted attribute to be true and update submitted_at time" do
        expect(@broker.submitted).to be true
        expect(@broker.submitted_at).to be_present        
      end
    end
      describe "associate and disassocite with broker through QuoteRelations" do
    before do
      @user=FactoryGirl.create(:user)
      @broker=FactoryGirl.create(:broker)
    end
  end
  describe "when broker is updated" do
    before do
      @broker=FactoryGirl.build(:broker)
      @broker.save
      @address=@broker.address
      @latitude=@broker.latitude
      @longitude=@broker.longitude
    end
    it "should call geocode if address is updated" do
      @broker.update(street:"61-29 223 Place",city:"Oakland Gardens",state:"New York")
      @broker=@broker.reload
      expect(@longitude).not_to eq "@broker.longitude"
      expect(@latitude).not_to eq "@broker.latitude"
    end
    it "shouldn't call geocode is address is the same" do
      @broker.update(street:"80-75 208 Street")
      @broker=@broker.reload
      expect(@longitude).to eq "@broker.longitude"
      expect(@latitude).to eq "@broker.latitude "       
    end
    it "shouldn't save state if it is invalid" do
      @broker.state="Nwe York"
      expect(@broker).not_to be_valid
    end
  end
    describe "Appointment Association" do
      before do
        @broker.save     @product=Product.create(name:"test",description:"test",product_type:1,firm_id:1)
      end
      it "appoint method should work" do
        expect{@broker.appoint(@product)}.to change(Appointment, :count).by(1)
      end
      it "unappoint method should work" do
        @broker.appoint(@product)
        expect{@broker.unappoint(@product)}.to change(Appointment, :count).by(-1)
      end
      it "appointed_with? should work" do
        expect(@broker.appointed_with?(@product)).to eq false
        @broker.appoint(@product)
        expect(@broker.appointed_with?(@product)).to eq true
      end
    end
    describe "Associated Licenses" do
      before do
        @license=FactoryGirl.build :license, broker:@broker
      end
      subject{@license}
      it {should respond_to (:picture)}
      it {should respond_to (:license_number)}
      it {should respond_to (:license_type)}

      describe "shouldn't save if license type is missing" do
        before do
          @license.license_type=nil
        end
        it {should_not be_valid}
      end  
      describe "shouldn't save if license number is missing" do
        before do
          @license.license_number=nil
        end
        it {should_not be_valid}
      end  
      describe "shouldn't save if picture is missing" do
        before do
          @license=FactoryGirl.build :no_picture_license, broker:@broker
        end
        subject{@license}
        it {should_not be_valid}
      end
      describe "shouldn't save if wrong document type of license is uploaded" do
        before do
          @license=FactoryGirl.build :doc_license, broker:@broker
        end
        subject{@license}
        it {should_not be_valid}
      end
      describe "shouldn't save if the same type of license has been saved for the broker" do
        before do
          @license_with_same_license_type=@license.dup
          @license_with_same_license_type.save
        end
        it {should_not be_valid}
      end
    end
  end
end
