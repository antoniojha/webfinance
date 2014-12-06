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
    it "should redirect to select_bank/new page if one tries to enter directly in url address" do
      get bank_login_path
  #    expect(page).to have_content("Invalid Bank")
      response.body.should include("Select Bank Account")
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
      # add js testing here in the future
      click_button "Login"
      expect(page).to have_content("Invalid Login Info")
    end
    it "should render to bank_login page with error if invalid username or password is entered" do
      fill_in "LOGIN", :with => 'invalid'
      fill_in "PASSWORD", :with => 'invalid'
      click_button "Login"
      expect(page).to have_content("Invalid Login Info")
    end
    # varies in a bank to bank basis
    if false
    it "should display account if correct username and password is entered" do
      fill_in "LOGIN", :with => 'antoniojha1'
      fill_in "PASSWORD", :with => '5577jha'
      expect {click_button "Login"}.to change(Account, :count).by(1)
      expect(page).to have_content('Accounts at')    
      #    save_and_open_page <-- save another tiime to make this work
    end
    it "should create Item Account upon successful login" do
      fill_in "LOGIN", :with => 'antoniojha1'
      fill_in "PASSWORD", :with => '5577jha'
      expect {click_button "Login"}.to change(AccountItem, :count).by(2)
    end
    end
    it "should not allow user logging in if an account has been created" do
   #    fill_in "LOGIN", :with => 'antoniojha1'
   #    fill_in "PASSWORD", :with => '5577jha'
   #    click_button "Login"
       get bank_login_url, :content_service_id => bank.content_service_id
       expect(page).to have_content(bank.content_service_display_name)
       post_via_redirect bank_login_url, :content_service_id => bank.content_service_id,:LOGIN=>'antoniojha1', :PASSWORD=>"5577jha"
  #     click_button "Login"
       expect(page).to have_content('Accounts at') 
    end
  end
end