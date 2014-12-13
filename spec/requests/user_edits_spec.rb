require 'rails_helper'

RSpec.describe "UserEdits", :type => :request do
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
