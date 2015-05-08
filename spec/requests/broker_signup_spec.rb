require 'rails_helper'

describe "Broker Signup" do
  describe " valid signup" do
    let(:broker){ FactoryGirl.build(:broker)}
    before do
      visit register_signup_path
      fill_in "broker_username", :with=>broker.username
      fill_in "broker_password", :with=>broker.password
      fill_in "broker_password_confirmation", :with=>broker.password 
    end   
    it "should visit signup page" do
      expect(page).to have_content('Sign Up')
    end
    it "should create broker" do
      expect { click_button "Create Account" }.to change(Broker, :count).by(1)  
    end
    it "should redirect to broker edit page to prompt broker to complete profile after sign up" do 
      click_button "Create Account"
      expect(page).to have_content("Update Profile")
    end    
  end
  describe "invalid signup" do
    let(:broker){ FactoryGirl.build(:broker)}
    before {visit register_signup_path}
    it "should display validation error" do
      expect(page).to have_content('Sign Up')
      click_button "Create Account"
      expect(page).to have_content('error')
      expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
    end
    it "should display error if password don't match" do
      fill_in "broker_password", with: broker.username
      fill_in "broker_password_confirmation", with: "random"
      click_button "Create Account"
      expect(page).to have_content('error')
      expect(page).to have_content("passwords do not match")
    end
  end
end