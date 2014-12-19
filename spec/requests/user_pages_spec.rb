require 'rails_helper'

RSpec.describe "UserEdits", :type => :request do
  describe "user edit page" do
    before do 
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit edit_user_path(@user)
    end
    describe "unsuccessful update" do

      it "should render error message" do
        fill_in "Password", :with=>"invalid"
        click_button "Update Account"
        expect(page).to have_content('error')
        expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
      end
    end
    describe "successful update" do
      it "should redirect to user/show page" do
        fill_in "Password", :with=> @user.password+'1'
        fill_in "Password confirmation", :with=> @user.password+'1'
        click_button "Update Account"
        expect(page).to have_content('User was successfully updated')
      end
    end
  end
  describe "user index page" do
    before do
      @user1=FactoryGirl.create(:user)
      @user2=FactoryGirl.create(:other_user)
      log_in(@user1)
      visit users_path
    end
    it "should have the right elements" do
      expect(page).to have_title("WebFinance App|All Users")
      expect(page).to have_selector('h1',text:'All Users')
    end
    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector(:css,'td',text:user.first_name)
      end
    end
    
  end
end
