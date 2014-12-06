require 'rails_helper'
describe User do
  describe "Creating User" do
    before { @user=User.new(username:"Example User", email:"example@example.com", password: "Example_password12?", password_confirmation: "Example_password12?")}
    subject {@user}
    it {should respond_to(:username)}
    it {should respond_to(:email)}
    it {should respond_to(:password_digest)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {should be_valid}
    describe "email_confirmation token" do
      before{@user.save}
      it{expect(@user.email_confirmation_token).should_not be_blank}
      it{expect(@user.email_confirmation_sent_at).should_not be_blank}
    end
    describe "auth_token" do
      before{@user.save}
      it{expect(@user.auth_token).should_not be_blank}
    end
    describe "test when name is not entered" do
      before {@user.username=" "}
      it {should_not be_valid}
    end
    describe "test when email is not entered" do
      before {@user.email=" "}
      it {should_not be_valid}
    end

    describe "when email is already registered" do
      before do
        @user_with_same_email=@user.dup
        @user_with_same_email.username="Different Example User"
        @user_with_same_email.save
      end
      it "should not be valid" do
        expect(@user).not_to be_valid 
      end
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
    end

    describe "when password is different from password_confirmation" do 
      before do
        @user_with_different_password=@user.dup
        @user_with_different_password.password_confirmation= "Example_password12!"
        @user_with_different_password.save
      end 
      it "should not be valid" do
        expect(@user_with_different_password).not_to be_valid
      end
    end
    describe "return value of authenticate method" do
      before{@user.save}
      let(:found_user){User.find_by(email: @user.email)}
      describe "with valid password" do
        it{ should eq found_user.authenticate(@user.password)}
      end
      describe "with invalid password" do
        let(:invalid_found_user){found_user.authenticate("invalid")}
        it {should_not eq invalid_found_user}
        specify {expect(invalid_found_user).to eq false}
      end
    end
    describe "when password is too long" do
      before {@user.password="A!1"+"a"*48} #exceed 50
      it {should_not be_valid}
    end
    describe "when password is too short" do
      before {@user.password="A!1"+"a"*3} #less than 7
      it {should_not be_valid}
    end
    describe "when email address with uppercase is saved already" do
      before do
        user_with_same_email=@user.dup
        user_with_same_email.email=@user.email.upcase
        user_with_same_email.save
      end
      it  {should_not be_valid}
    end
    describe "when email format is valid" do
      it "should be valid" do
        addresses=%w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email=valid_address
          expect(@user).to be_valid
        end
      end
    end
    describe "when email format is invalid" do
      it "should be invalid" do
        addresses=%w[user.foo,com user_at_foo.org example.user@foo. foo@bar_baz.com  foo@baz+baz.com]
        addresses.each do |invalid_address|
          @user.email=invalid_address
          expect(@user).not_to be_valid
        end
      end
    end
    describe "email downcasting" do
      let(:mixed_case_email){"MIXED_case@example.com"}
      it "should downcase email" do
        @user.email=mixed_case_email
        @user.save
        expect(@user.reload.email).to eq @user.email.downcase
      end
    end
    
    describe "username downcasting" do
      let(:mixed_case_username){"MIXED_case_username"}
      it "should downcase username" do
        @user.username=mixed_case_username
        @user.save
        expect(@user.reload.username).to eq @user.username.downcase
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
  end
  
  describe "#send confirmation_password" do
    let(:user){FactoryGirl.create(:user)}
    it "generates email autentication each time" do
      user.send_email_confirmation
      last_token=user.email_confirmation_token
      user.send_email_confirmation
      expect(user.email_confirmation_token).not_to eq(last_token)
    end
    it "saves the time email confirmation was sent" do
      user.send_email_confirmation
      expect(user.reload.email_confirmation_sent_at).to be_present
    end
    it "should send email to user" do
      user.send_email_confirmation
      expect(last_email.to).to include (user.email)
    end 
  end
end
