require 'rails_helper'

describe "Users Signup" do
  describe " valid signup" do
    let(:user){ FactoryGirl.build(:user)}
    before do
      visit signup_path
      fill_in "Username", :with=>user.username
      fill_in "Password", :with=>user.password
      fill_in "Password confirmation", :with=>user.password 
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
    #  expect(page).to have_content('Email Confirmation')
    #  expect(last_email.to).to include(user.email)
    end    
  end
  describe "invalid signup" do
    before {visit signup_path}
    it "should display validation error" do
      expect(page).to have_content('Sign Up')
      click_button "Create Account"
      expect(page).to have_content('error')
      expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
    end
  end
  
 # describe "invalid sign in" do
 #   before {visit login_path}
 #   it "should display validation error" do
 #     expect(page).to have_content('Login')
 #     click_button "Login"
 #     expect(page).to have_content('Invalid user')
 #   end
 # end
end
