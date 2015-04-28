require 'rails_helper'

describe "user sign in" do
  before do
    visit user_login_path
  end
  describe "sign in when user's has not confirmed email yet" do
    before do       
      @user=FactoryGirl.create(:incomplete_user)
      fill_in "session_name_or_email", :with=>@user.username
      fill_in "session_password", :with=>@user.password 
      click_button "Login"
    end
    it "should redirect to user edit page to prompt user to complete profile after sign in" do
      expect(page).to have_content("Update Profile")    
    end   
    describe "the user can validate email" do
      before do
        fill_in "user_email", with: "antoniojha@gmail.com"
        click_button "send validation code"
      end
      it "without any validation error for empty first_name or last_name" do
        expect(page).not_to have_content('error')
      end
      it "email authentication code is generated and email is sent" do
        @user.reload
        expect(@user.email_confirmation_token).not_to eq nil
        expect(last_email.to).to include (@user.email)
      end
      it "the user then enters validation code, first name and last name to direct to profile" do
        @user.reload
        fill_in "user_validation_code", with: @user.email_confirmation_token
        fill_in "user_first_name", with: "Antonio"
        fill_in "user_last_name", with: "Jha"
        click_button "Update Account"
        expect(page.title).to eq "RichRly|User Profile"        
      end
    end

    describe "sign in after user has confirmed email" do
      before do
        @user_complete=FactoryGirl.create(:user)
        fill_in "session_name_or_email", :with=>@user_complete.username
        fill_in "session_password", :with=>@user_complete.password 
        click_button "Login"
      end
      it "should redirect to user profile after sign in" do
        expect(page.title).to eq "RichRly|User Profile"
      end    
    end
    describe "invalid sign in" do
      it "should show message for invalid login if no username or password is entered" do
        click_button "Login"
        expect(page).to have_content('Invalid user/password combination')
      end
    end
  end
end
