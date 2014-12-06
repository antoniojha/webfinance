require 'rails_helper'

describe "user sign in" do
    before do 
      @user=FactoryGirl.create(:user)
      @user.save
      visit login_path
      expect(page).to have_content('Login')

    end
    it "shouldn't sign in but direct to Email Confirmation page b/c user's has not confirmed email yet" do  
      fill_in "Username", :with=>@user.username
      fill_in "Password", :with=>@user.password 
      click_button "Login"
      expect(page).to have_content('Email Confirmation')
    end
    describe "sign in/out" do
      before do 
        @user.update_attributes(email_authen:'true')
        fill_in "Username", :with=>@user.username
        fill_in "Password", :with=>@user.password 
        click_button "Login"
      end
      it "should sign in after use confirmed email" do
        expect(page).to have_link('Account')
        expect(page).to have_link('Log Out')
        expect(page).not_to have_link('Sign In')
        expect(page).not_to have_link('Sign Up')     
      end
      describe "sign out" do
        
        before{click_link 'Log Out'}
        it "should sign out and redirect to Login in page" do
          expect(page).to have_link('Sign In')
          expect(page).to have_selector('div.alert.alert-notice.notice',text:"Logged Out")
          expect(page).to have_content('Sign In')
        end
      end
    end  

    it "should show message for invalid login" do
      click_button "Login"
      expect(page).to have_content('Invalid user/password combination')
    end
    
end
