require 'rails_helper'

describe "Broker Edit page" do
  before do
    @broker=FactoryGirl.create(:broker)
    setup_broker_requests(@broker)
   # @broker.experiences.create(company:@broker.company_name, title:@broker.title)
    broker_login(@broker)
  end
  describe "at the personal edit page" do
    before do
      visit broker_path(@broker)
    
    end
    it "should be at the edit page" do
      expect(page.title).to eq("RichRly|Broker Profile")
    end
  end
end
