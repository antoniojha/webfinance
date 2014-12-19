require 'rails_helper'

RSpec.describe "Spendings", :type => :request do
  before do
    @user=FactoryGirl.create(:user)
    @user2=FactoryGirl.create(:other_user)
    log_in(@user)
  end
  
  describe "Spending index" do
    before do
      @spending=create_spending(@user)
      @spending2=create_spending(@user2)

      visit spendings_path 
    end
    it "should list spendings" do
      expect(page).to have_title ("WebFinance App|All Spendings")
      expect(page).to have_selector(:css, 'td',text:@spending.description)
    end
    it "should have link to show each spending" do
      expect(page).to have_link('Detail')
      click_link('Detail')
      expect(page).to have_content('Transaction Detail')
    end
    #check
    it "should display spendings that belong to each user" do
      expect(page).not_to have_content('different description')
    end
  end
  describe "Spending Show" do
    before do
      @spending=FactoryGirl.create(:spending)
      visit spending_path(@spending)
    end
    it "should show the right links" do
      expect(page).to have_title('WebFinance App|Spending Show')
      expect(page).to have_content("Transaction date")
      expect(page).to have_content("Description")
    end
  end
  describe "Spending Edit" do
    before do
      @spending=FactoryGirl.create(:spending)
      visit edit_spending_path(@spending)
    end
    it "should have the right title and link" do
      expect(page.title).to eq('WebFinance App|Edit Spending')
      expect(page).to have_link('Back')
    end
    it "should succesfully update spending" do
      
      fill_in "Description", with: "Edit Description"
      click_button "Update Transaction"
      expect(page).to have_title('WebFinance App|All Spendings')
      expect(page).to have_selector(:css,'div.notice',text:'Spending was successfully updated.')
    end
    it "should display error if unsuccessful update" do
      fill_in "Description", with:""
      click_button "Update Transaction"
      expect(page).to have_content('error')
      expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
    end
  end
end
