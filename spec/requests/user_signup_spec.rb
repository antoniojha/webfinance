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
    it "should redirect to user setup page to prompt user to profile after sign up" do 
      click_button "Create Account"
      expect(page.title).to eq("RichRly|User Setup")
    end    
    it "should goes to setup page- basic info" do
      click_button "Create Account"
      expect(page).to have_content("Please fill in basic info")
    end
    describe "initial setup page" do
      before{click_button "Create Account"}
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
