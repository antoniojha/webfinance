require 'rails_helper'

describe Broker do
  describe "Create Broker" do
    before do
      @broker=Broker.new(username:"testing",email:"example@example.com",password: "6004Aj?", password_confirmation:"6004Aj?")
    end
    subject {@broker}
    it {should respond_to(:username)}
    it {should respond_to(:email)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {should respond_to(:password_digest)}
    it {should respond_to(:salt)}
    it {should respond_to(:password_confirmation_token)}
    it {should respond_to(:password_reset_send_at)}
    it {should respond_to(:current_experience_id)}
    it {should respond_to(:email_confirmation_token)}
    it {should respond_to(:auth_token_digest)}
    it {should respond_to(:image)}
    it {should respond_to(:id_image)}
    it {should respond_to(:first_name)}
    it {should respond_to(:last_name)}
    it {should respond_to(:company_name)}
    it {should respond_to(:company_location)}
    it {should respond_to(:phone_number_work)}
    it {should respond_to(:phone_number_cell)}
    it {should respond_to(:title)}
    it {should respond_to(:web)}
    it {should respond_to(:ad_statement)}
    it {should respond_to(:check_term_of_use)}
    it {should respond_to(:license_type)}
    it {should respond_to(:product_ids)}
    it {should respond_to(:approved)}
    it {should respond_to(:setup_completed?)}
    
    it {should be_valid}
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
    describe "when password is not entered" do
      before do 
        @broker.password=""
        @broker.non_signup_provider_bool=true
      end
      it {should_not be_valid}      
    end
    describe "when password confirmation is not entered" do
      before do
        @broker.password_confirmation=""
        @broker.non_signup_provider_bool=true
      end
      it {should_not be_valid}        
    end
    describe "when password is different from password_confirmation" do 
      before do
        @broker3=@broker.dup
        @broker3.password_confirmation= ""
        @broker3.non_signup_provider_bool=true
      end 
      it "should not be valid" do
        @broker3.save
        expect(@broker3).not_to be_valid
      end
      it "now with the same password the broker should be valid" do
        @broker3.password_confirmation=@broker3.password
        expect(@broker3).to be_valid
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
  end
end
