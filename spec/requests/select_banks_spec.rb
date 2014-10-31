require 'rails_helper'

RSpec.describe "SelectBanks", :type => :request do
  subject {page}
  describe "select bank and redirect to login page" do
    before{ visit new_select_bank_path}
    it "should redirect to bank login page is a bank is selected" do
      load "#{Rails.root}/db/seeds.rb" 
      select "1st Bank (US)", :from => "bank_id"
      click_button "Next"
      expect(page).to have_content("Bank Login")
    end
    it "should render to select_banks/new page if no bank is selected" do
      click_button "Next"
      expect(page).to have_content("Please select a bank")
    end
  end
  describe "login page" do
    before{ visit bank_login_path}
    it "should have the right login form" do
      load "#{Rails.root}/db/seeds.rb" 
      
    end
  end
end
