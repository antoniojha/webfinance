require 'rails_helper'

describe "user sign in" do
  before do
    visit user_login_path
  end

  describe "initial sign up" do
    before do
      @user=FactoryGirl.create(:incomplete_user)
      @user.update_attribute(:setup_completed?,false)
      fill_in "session_name_or_email", :with=>@user.username
      fill_in "session_password", :with=>@user.password 
      click_button "Login"
    end
  
    it "should goes to setup page- basic info" do
      expect(page).to have_content("Please fill in basic info")
    end
    describe "without filling out information and submit basic information page" do
      before {click_button "Next"}
      it "should show error messages" do
        expect(page).to have_content("error")
        expect(page).to have_content("First name can't be blank")
        expect(page).to have_content("Last name can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Age level can't be blank")
        expect(page).to have_content("Income level can't be blank")
        expect(page).to have_content("State can't be blank")
      end
    end
  
    describe "2nd page" do
      before do
        select("0 to $30,000",from:"user_income_level")
        select("New York", from:"user_state")
        select("20-39 years old",from: "user_age_level") 
        fill_in "user_email", with: "example@example.com"
        fill_in "user_occupation", with: "teacher"   
        fill_in "user_first_name", with: "Antonio"
        fill_in "user_last_name", with: "Jha"
        
        click_button "Next"
      end

      it "should go to the 2nd page-goals" do       
        expect(page).to have_content("Please select your goal")
      end
      describe "select goals" do
        before do
          check "user_goal_investment"
          click_button "Submit"
        end
        it "should go to the user edit page to prompt user to validate email" do
          expect(page).to have_title("RichRly|Edit User") 
        end
      end
  
      describe "click previous button" do
        before do
          click_button "Previous"
        end
        it "should go back to the previous page without any error message" do
          expect(page).to have_content("Please fill in basic info")
        end
      end
 
      describe "click submit button" do
        before do
          click_button "Submit"
        end
        it "should display validation error for no goal selected" do
          expect(page).to have_content("error")
          expect(page).to have_content("Need to select a financial goal")
        end
      end
    end
  end

  describe "sign in after initial setup when user's has not confirmed email yet" do
    before do       
      @user=FactoryGirl.create(:incomplete_user)
      @user.update_attribute("setup_completed?",true)
      @user.email_authen=false
      @user.save
      fill_in "session_name_or_email", :with=>@user.username
      fill_in "session_password", :with=>@user.password 
      click_button "Login"
    end
    it "should redirect to user edit page to prompt user to complete profile after sign in" do
      expect(page).to have_title("RichRly|Edit User")    
    end   
    it "user can update first and last name without running into validation error to require email address be entered" do
      fill_in "user_first_name", with: "first_name"
      fill_in "user_last_name", with: "last_name"
      click_button "Update Account"
      expect(page).not_to have_content('error')
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
        click_button "validate email"
        expect(page).to have_content("Email address is successfully validated")
        fill_in "user_first_name", with: "Antonio"
        fill_in "user_last_name", with: "Jha"
        click_button "Update Account"
        expect(page.title).to eq "RichRly|User Profile"        
      end
    end
  end
  
  describe "sign in after setup and user has confirmed email" do
    before do
      @user_complete=FactoryGirl.create(:user)
    end
    it "should redirect to user profile after sign in with username" do
      fill_in "session_name_or_email", :with=>@user_complete.username
      fill_in "session_password", :with=>@user_complete.password 
      click_button "Login"
      expect(page.title).to eq "RichRly|User Profile"
    end   
    it "should redirect to user profile after sign in with username" do
      fill_in "session_name_or_email", :with=>@user_complete.email
      fill_in "session_password", :with=>@user_complete.password 
      click_button "Login"
      expect(page.title).to eq "RichRly|User Profile"
    end    
    describe "when user is entering a new email in user edit page" do
      before do
        fill_in "session_name_or_email", :with=>@user_complete.email
        fill_in "session_password", :with=>@user_complete.password 
        click_button "Login"       
      end
      it "there should be no change if user enters and update the same email as before" do
        visit edit_user_path(@user_complete)
        fill_in "user_email", with: @user_complete.email
        click_button "send validation code"
        @user_complete.reload
        expect(@user_complete.email_confirmation_token).to eq nil
        expect(@user_complete.email_authen).to eq true #test user.evaluate_and_reset_email_authen
        expect(last_email).to eq nil
      end
      it "there sould be change if user enters and update a different email" do
        visit edit_user_path(@user_complete)
        fill_in "user_email", with: "jha@cooper.edu"
        click_button "send validation code"
        @user_complete.reload
        expect(@user_complete.email_confirmation_token).not_to eq nil  
        expect(@user_complete.email_authen).to eq false #test user.evaluate_and_reset_email_authen
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
  describe "when user forgets password" do
    before do
      @user_complete=FactoryGirl.create(:user)
      @prev_password=@user_complete.password_digest
      click_link("Forgot Password?")
    end
    it "should go to password_prompt page" do
      expect(page).to have_content("Enter Your Username")
    end
    describe "user fills in his username" do
      before do
        fill_in "session_username", with:@user_complete.username
        click_button "Submit"
      end
      it "should display user's email" do
        expect(page).to have_content(@user_complete.email)
      end
      describe "user clicks 'Send New Password' button" do
        before do
          click_button "Send New Password"
          it "should generate a temporary password and send email to user" do
            expect(last_email.to).to include @user_complete.email
            expect(@user_complete.password_digest).not_to eq (@prev_password)
          end
        end
      end
    end
  end

end
