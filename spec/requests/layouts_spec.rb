require 'rails_helper'

RSpec.describe "Layouts", :type => :request do
  describe "bootstrap layout for different controller" do
    before do 
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit spendings_path
    end
    it "should have mol-md-6 for middle column in spending" do
      expect(page.find("#col_middle")[:class]).to eq ("col-md-6")
    end
    it "should have mol-md-8 for middle column in other controller" do
      visit login_url
      expect(page.find("#col_middle")[:class]).to eq ("col-md-8")
    end
  end
  
end
