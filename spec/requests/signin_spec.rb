require 'rails_helper'

describe "user sign in" do
  before do 

    visit user_login_path
    expect(page).to have_content('Login to RichRly') 
  end
  describe "sign in when user's has not confirmed email yet" do
    before do
      @user=FactoryGirl.create(:incomplete_user)
      fill_in "session_name_or_email", :with=>@user.username
      fill_in "session_password", :with=>@user.password 
      click_button "Login"
    end
    it "should redirect to user edit page to prompt user to complete profile after sign in" do
      expect(page).to have_content(@user.first_name)
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
      expect(page).to have_content("Update Profile")
    end    
  end
  describe "invalid sign in" do
    it "should show message for invalid login if no username or password is entered" do
      click_button "Login"
      expect(page).to have_content('Invalid user/password combination')
    end
  end
end
