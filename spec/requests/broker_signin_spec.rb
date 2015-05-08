require 'rails_helper'

describe "broker sign in" do
  before do
    visit broker_login_path
  end
  describe "sign in when broker's has not confirmed email yet" do
    before do       
      @broker=FactoryGirl.create(:incomplete_broker)
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
    end
    it "should redirect to broker edit page to prompt broker to complete profile after sign in" do
      expect(page).to have_content("Update Profile")    
    end   
    it "broker can update first and last name without running into validation error to require email address be entered" do
      fill_in "broker_first_name", with: "first_name"
      fill_in "broker_last_name", with: "last_name"
      click_button "Update Account"
      expect(page).not_to have_content('error')
    end
    describe "the broker can validate email" do
      before do
        fill_in "broker_email", with: "antoniojha@gmail.com"
        click_button "send validation code"
      end
      it "without any validation error for empty first_name or last_name" do
        expect(page).not_to have_content('error')
      end
      it "email authentication code is generated and email is sent" do
        @broker.reload
        expect(@broker.email_confirmation_token).not_to eq nil
        expect(last_email.to).to include (@broker.email)
      end
      it "the broker then enters validation code, first name and last name to direct to profile" do
        @broker.reload
        fill_in "broker_validation_code", with: @broker.email_confirmation_token
        click_button "validate email"
        expect(page).to have_content("Email address is successfully validated")
        fill_in "broker_first_name", with: "Antonio"
        fill_in "broker_last_name", with: "Jha"
        click_button "Update Account"
        expect(page.title).to eq "RichRly|Broker Profile"        
      end
    end
  end
  
  describe "sign in after broker has confirmed email" do
    before do
      @broker_complete=FactoryGirl.create(:broker)
    end
    it "should redirect to broker profile after sign in with username" do
      fill_in "session_name_or_email", :with=>@broker_complete.username
      fill_in "session_password", :with=>@broker_complete.password 
      click_button "Login"
      expect(page.title).to eq "RichRly|Broker Profile"
    end   
    it "should redirect to broker profile after sign in with username" do
      fill_in "session_name_or_email", :with=>@broker_complete.email
      fill_in "session_password", :with=>@broker_complete.password 
      click_button "Login"
      expect(page.title).to eq "RichRly|Broker Profile"
    end    
    describe "when broker is entering a new email in user edit page" do
      before do
        fill_in "session_name_or_email", :with=>@broker_complete.email
        fill_in "session_password", :with=>@broker_complete.password 
        click_button "Login"       
      end
      it "there should be no change if broker enters and update the same email as before" do
        visit edit_broker_path(@broker_complete)
        fill_in "broker_email", with: @broker_complete.email
        click_button "send validation code"
        @broker_complete.reload
        expect(@broker_complete.email_confirmation_token).to eq nil
        expect(@broker_complete.email_authen).to eq true #test broker.evaluate_and_reset_email_authen
        expect(last_email).to eq nil
      end
      it "there sould be change if broker enters and update a different email" do
        visit edit_broker_path(@broker_complete)
        fill_in "broker_email", with: "jha@cooper.edu"
        click_button "send validation code"
        @broker_complete.reload
        expect(@broker_complete.email_confirmation_token).not_to eq nil
        expect(@broker_complete.email_authen).to eq false #test broker.evaluate_and_reset_email_authen
        expect(last_email.to).to include "jha@cooper.edu"
      end
    end
  end
  describe "invalid sign in" do
    it "should show message for invalid login if no username or password is entered" do
      click_button "Login"
      expect(page).to have_content('Invalid username or email/password combination')
    end
  end
end
