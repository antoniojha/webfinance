require 'rails_helper'
describe User do
  describe "Creating User" do
    before do
      @user=User.new( username:"example user", email:"example@example.com", password: "Example_password12?", password_confirmation: "Example_password12?",first_name:"firstname",last_name:"lastname", phone_number:"1"*10)
      @user2=User.create(username:"example user2", email:"example2@example.com",password:"Example_password12?",password_confirmation:"Example_password12?", street:"80-75 208 Street", city:"Hollis Hills", state:"NY")
    
    end
    subject {@user}
    it {should respond_to(:first_name)}
    it {should respond_to(:last_name)}
    it {should respond_to(:username)}
    it {should respond_to(:email)}
    it {should respond_to(:provider)}
    it {should respond_to(:uid)}
    it {should respond_to(:password_digest)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {should respond_to(:admin)}
    it {should be_valid}
    describe "shouldn't save when username is not entered" do
      before {@user.username=""}
      it {should_not be_valid}
    end

    describe "when username is already registered" do
      before do
        @user_with_same_name=@user.dup
        @user_with_same_name.email="different_example@example.com"
        @user_with_same_name.save
      end
      it "should not be valid" do
        expect(@user).not_to be_valid 
      end
      it "should not be valid even if username has differenct case" do
        @user.username=@user.username.capitalize
        expect(@user).not_to be_valid
      end
    end
    describe "when password is not entered" do
      before {@user.password=""}
      it {should_not be_valid}      
    end
    describe "when password confirmation is not entered" do
      before {@user.password_confirmation=""}
      it {should_not be_valid}        
    end
    describe "when password is different from password_confirmation" do 
      before do
        @user3=@user.dup
        @user3.password_confirmation= ""
      end 
      it "should not be valid" do
        @user3.save
        expect(@user3).not_to be_valid
      end
      it "now with the same password the user should be valid" do
        @user3.password_confirmation=@user3.password
        expect(@user3).to be_valid
      end
    end
    describe "when password format is invalid" do
      it "should be invalid" do
        passwords=%w[aaaaaa1 aaaaaaA AAAAAA1]
        passwords.each do |invalid_address|
          @user.password=invalid_address
          @user.password_confirmation=invalid_address
          expect(@user).not_to be_valid
        end
      end
    end
    describe "when password is too long" do
      before do
        @user.password="A!1"+"a"*40
        @user.password_confirmation=@user.password
      end
      it "should not be valid" do
        expect(@user).not_to be_valid
      end
    end
    describe "when password is too short" do
      before do
        @user.password="A!1a"
        @user.password_confirmation=@user.password
      end
      it "should not be valid" do
        expect(@user).not_to be_valid
      end
    end
  end
end
