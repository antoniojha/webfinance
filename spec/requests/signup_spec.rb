require 'rails_helper'

describe "Users Signup" do
  describe " valid signup" do
    let(:user){ FactoryGirl.build(:user)}
    before do
      visit signup_path
      fill_in "user_username", :with=>user.username
      fill_in "user_password", :with=>user.password
      fill_in "user_password_confirmation", :with=>user.password 
    end   
    it "should visit signup page" do
      expect(page).to have_content('Sign Up')
    end
    it "should create user" do
      expect { click_button "Create Account" }.to change(User, :count).by(1)  
    end
    it "should redirect to user edit page to prompt user to complete profile after sign up" do 
      click_button "Create Account"
      expect(page).to have_content("Update Profile")
    end    
  end
  describe "invalid signup" do
    let(:user){ FactoryGirl.build(:user)}
    before {visit signup_path}
    it "should display validation error" do
      expect(page).to have_content('Sign Up')
      click_button "Create Account"
      expect(page).to have_content('error')
      expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
    end
    it "should display error if password don't match" do
      fill_in "user_password", with: user.username
      fill_in "user_password_confirmation", with: "random"
      click_button "Create Account"
      expect(page).to have_content('error')
      expect(page).to have_content("passwords do not match")
    end
  end
end
