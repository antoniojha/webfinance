require 'rails_helper'
describe "select_bank page series" do
  describe "select bank page" do

    let(:bank){FactoryGirl.build(:bank)}
    before do    
      FactoryGirl.create(:bank)
      visit new_select_bank_path
    end
    it "should be at select_bank/new page" do
      expect(page).to have_content("Select Bank Account")
    end
    it "should redirect to bank login page if a bank is selected" do     
      select bank.content_service_display_name, :from => "content_service_id"
      click_button "Next"
      expect(page).to have_content(bank.content_service_display_name) 
    end
    it "should render to select_bank/new page with error notice if nothing is selected" do            
      click_button "Next"
      expect(page).to have_content("Select Bank Account")
      expect(page).to have_content("Please select a bank")
    end
  end

  describe "Login Page" do
    let(:bank){FactoryGirl.build(:chasebank)}
    before do     
      FactoryGirl.create(:chasebank)
      FactoryGirl.create(:user)

      visit new_select_bank_path
    #  find("option[value=13061]").click
    #  find('#content_service_id').find(:xpath, 'option').click
      select bank.content_service_display_name, :from => "content_service_id"
      click_button "Next"
    end
    it "should display Chase" do
      expect(page).to have_content(bank.content_service_display_name)
    end
    
    it "should render to bank_login page with error if no username or password is entered" do
      click_button "Login"
      expect(page).to have_content("Please specify your name")
    #  expect(page).to have_content("Bank Login")
    #  expect(page).to have_content("Login or Password Invalid")
    end
    it "should display account if correct username and password is entered" do
      fill_in "LOGIN", :with => 'antoniojha1'
      fill_in "PASSWORD", :with => '5577jha'
      expect(page).to have_content('Accounts at Chase')
    end
  end
end