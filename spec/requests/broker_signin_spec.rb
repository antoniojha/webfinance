require 'rails_helper'

describe "broker manual sign in" do
 
  before do      
    create_complete_broker
    visit broker_login_path
  end
  describe "proper sign in" do
    before do
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
    end
    it "should be at personal profile" do
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
    end
  end
  describe "sign out" do
    before do
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
    end
    it "should sign out" do
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
      click_link "Log Out"
      expect(page.title).to eq "RichRly|Broker Login"
      expect(page).to have_content("Logged Out")
    end
  end
  describe "improper sign in" do
    it "should render error if no username or password is entered" do
      click_button "Login"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Invalid username or email/password combination")
    end
    it "should render error if username and password does not match record" do
      fill_in "session_name_or_email", :with=>(@broker.username+"?")
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Invalid username or email/password combination")      
    end
  end
end
describe "security redirect" do
  describe "smart redirect" do
    before do
      create_complete_broker
      visit edit_broker_path(@broker)    
    end
    it "should redirect to login page" do
      expect(page.title).to eq "RichRly|Broker Login"
    end
    it "should redirect to edit page once login" do
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
      expect(page.title).to eq "RichRly|Edit Broker"
    end
  end
  describe "personal page security" do
    before do
      create_complete_broker
      visit edit_broker_path(@broker)    
    end   
    it "should redirect any other member to enter your personal setting page" do
      expect(page).to have_title("RichRly|Broker Login")
      expect(page).to have_content("Please Login")
    end
  end
  describe "when an invalid broker is accessed" do
    it "should redirect when show page is accessed" do
      visit broker_path(id:1)
      expect(page).to have_title("RichRly|Broker Login")
      expect(page).to have_content("Invalid Broker")
    end
    it "should redirect to Login page via authorize_broker_login action" do
      visit edit_broker_path(id:1)
      expect(page).to have_title("RichRly|Broker Login")
      expect(page).to have_content("Please Login")
    end  
  end
end 
describe "forgot password" do
  before do
    create_complete_broker
    visit broker_login_path
  end
  it "should have Forgot Password link" do
    expect(page).to have_link("Forgot your password?")
  end
  describe "click on Forgot your password link" do
    before do
      click_link("Forgot your password?")
    end
    it "should direct to password prompt page" do
      expect(page).to have_content("Enter your username or email")
    end
    describe "enter email address or username" do
      it "renders error if email address or username is unidentified" do
        fill_in "session_name_or_email", with: "something"
        click_button "Search"
        expect(page).to have_content("Enter your username or email")
        expect(page).to have_content("Username/email can't be found!")
      end
      describe "enter valid email address" do
        before do
          fill_in "session_name_or_email", with: @broker.email
          click_button "Search"
        end
        it "should be at password_lookup_2 page" do
          expect(page).to have_content("Reset Your Password")
        end
        it "should redirect back to password_prompt_1 page if it's not you" do
          click_button "Not You?"
          expect(page).to have_content("Enter your username or email")
        end
        it "broker password confirmation token should be empty" do
          expect(@broker.password_confirmation_token).to eq nil
        end
        it "should send reset password link if 'Send New Password button' is clicked" do
          click_button "Send New Password"
          @broker.reload
          expect(@broker.password_confirmation_token).not_to eq nil
        end
        describe "send confirmation token and redirect back to page to enter new password" do
          before do
            click_button "Send New Password"
            @broker.reload
            visit broker_enter_new_password_url(@broker.password_confirmation_token)
          end
          it "should be at enter_new_password_3 page" do
            expect(page).to have_content("Enter new password")
          end
          it "should change password if a valid password and confirmation pw are entered" do
            new_pw=@broker.password+'?'
            fill_in "broker_password", with: new_pw
            fill_in "broker_password_confirmation", with: new_pw
            click_button "Submit"
            @broker.reload
            expect(@broker.has_password?(new_pw)).to eq true
            expect(page).to have_title("RichRly|Broker Login")
          end
          it "should render error if password is invalid" do
            fill_in "broker_password", with: "invalid"
            fill_in "broker_password_confirmation", with: "invalid"            
            click_button "Submit"
            expect(page).to have_selector(:css, 'div.alert.alert-danger')
          end
          it "should redirect back to password_lookup_2 page if pw was sent more than 2 hours ago" do
            @broker.password_reset_send_at=3.hours.ago
            @broker.save
            fill_in "broker_password", with: @broker.password
            fill_in "broker_password_confirmation", with: @broker.password           
            click_button "Submit"        
            expect(page.title).to eq ("RichRly|Password Reset 2")
            expect(page).to have_content("Password reset has expired.")
          end
        end
      end
    end
  end
end
RSpec.describe Broker::SessionsController, :type => :controller do
  describe "broker sign in" do
    before do
       create_complete_broker
    end
    subject{@broker}
    describe "testing remember me/login feature" do
      it "should create session and cookies when broker check remember me" do
        expect(request.cookies['broker_id']).to eq (nil)
        post :create, session:{name_or_email: @broker.username, password: @broker.password, remember: '1'}
        response.should redirect_to @broker
        expect(response.cookies['broker_id']).not_to eq (nil)
        expect(session['broker_id']).to eq @broker.id
      end
      it "should create session but not cookies when user doesn't check remember me box" do
        expect(request.cookies['broker_id']).to eq (nil)
        post :create, session:{name_or_email: @broker.username, password: @broker.password, remember: '0'}
        response.should redirect_to @broker
        expect(response.cookies['broker_id']).to eq (nil)
        expect(session['broker_id']).to eq @broker.id
      end
    end
    describe "testing logout feature" do
      before do
        post :create, session:{name_or_email: @broker.username, password: @broker.password, remember: '1'}
      end
      it "cookies and session should be populated" do
        expect(response.cookies['broker_id']).not_to eq nil
        expect(session['broker_id']).to eq @broker.id
      end
      it "should clear cookies and session once log out" do
        delete :destroy
        expect(response.cookies['broker_id']).to eq nil
        expect(session['broker_id']).to eq nil
      end
    end
  end
end