require 'rails_helper'

describe "Broker Edit page" do
  before do
    @broker=FactoryGirl.create(:broker)
   
    @broker.experiences.create(company:@broker.company_name, title:@broker.title)
    broker_log_in(@broker)
  end
  describe "at the personal edit page" do
    before do
      visit broker_path(Broker.first)
    
    end
    it "should be at the edit page" do
      expect(page.title).to eq("RichRly|Broker Profile")
    end
  end
end
