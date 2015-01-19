require 'rails_helper'

RSpec.describe "BackgroundPages", :type => :request do
 
  describe "Background Pages-the 1st page (Background)" do
    before do
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit new_background_path
      fill_in "background_dob_string", with:"09/18/1987"
      choose "background_married_false"
      fill_in "background_children", with:"3"
      select "New York", from:"background_state"   
    end
    it "should have only next button" do
      expect(page).to have_button "Next"
      expect(page).not_to have_button "Prev"
      # the below test is to make sure that when the user goes back to the edit form (no longer new form) it will still have the correct display
      expect(page.title).to eq("WebFinance App|financial planning page 1")
      click_button "Next"
      expect(page.title).to eq("WebFinance App|financial planning page 2")
      click_button "Prev"
      expect(page).to have_button "Next"
      expect(page).not_to have_button "Prev"
    end

  end
end
