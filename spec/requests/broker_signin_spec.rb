
require 'rails_helper'

describe "broker sign in" do
 
  before do      
    for i in 0..(2)
      Product.create(name:"name#{i}", description:"description#{i}", vehicle_type:1)
    end
    @broker=FactoryGirl.create(:broker)
    @setup_broker=@broker.build_setup_broker
    @setup_broker.save
    for i in 0..1
      type=@broker.license_type[i]
      @setup_broker.licenses.create(license_type:type, license_number:"test")
    end
    visit broker_login_path
  end
  describe "proper sign in" do
    before do
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
    end
    it "should be at profile" do
      expect(page.title).to eq "RichRly|Broker Profile"
    end
  end
  describe "improper sign in" do
    it "should render error if no username or password is entered" do
      click_button "Login"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Invalid username or email/password combination")
    end
    it "should render error if username and password does not match record" do
      fill_in "session_name_or_email", :with=>(@broker.username+"?")
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Invalid username or email/password combination")      
    end
  end
end
