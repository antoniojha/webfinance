require 'rails_helper'


  describe "select bank page" do
    before do 
      bank= FactoryGirl.create(:chasebank)
      visit new_select_bank_path
    end
    it "should redirect to bank login page if a bank is selected" do
      select bank.content_service_display_name, :from => "content_service_id"
      click_button "Next"
      expect(page).to have_content("Bank Login")
      expect(page).to have_content(bank.content_service_display_name) 
    end

  end
  describe "select bank" do
    before {visit new_select_bank_path}
    it "should render to select_bank/new page if nothing is selected" do            
      click_button "Next"
      expect(page).to have_content("Select Bank Account")
      expect(page).to have_content("Please select a bank")
    end
  end

