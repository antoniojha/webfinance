require 'rails_helper'

RSpec.describe "SelectBanks", :type => :request do
  subject {page}
  describe "select bank and redirect to login page" do
    before{ visit select_banks_path}
   # second_option_xpath = "//*[@id='bank_id']/option[2]"
   # second_option = find(:xpath, second_option_xpath).text
   # select(second_option, :from => bank_id)
    click_button "Next"
    expect(page).to have_content("Bank Login")
  end
end
