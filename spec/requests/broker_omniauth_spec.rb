require 'rails_helper'

describe "broker social media sign up" do
  before do
    extend OmniauthMacros
    OmniAuth.config.test_mode = true
    visit broker_login_path
  end
  it "should be at broker login page" do
    expect(page.title).to eq "RichRly|Broker Login"
  end
  describe "sign up through twitter" do
    before do
      mock_auth_hash_twitter 
    end
    it "should create Broker and be at the first register page" do
      expect{click_link "twitter"}.to change(Broker, :count).by(1)
      expect(Broker.first.email_authen).to eq false
      expect(page).to have_content("Your Background Information")
     
    end
  end
  describe "sign up through linkedin" do
    before do
      mock_auth_hash_linkedin 
    end
    it "should create Broker and be at the first register page" do
      expect{click_link "linkedin"}.to change(Broker, :count).by(1)
      expect(Broker.first.email_authen).to eq true
      expect(page).to have_content("Your Background Information")
    end    
  end
 
  describe "sign up through facebook" do
    before do
      mock_auth_hash_facebook 
    end
    it "should create Broker and be at the first register page" do
      expect{click_link "facebook"}.to change(Broker, :count).by(1)
      expect(Broker.first.email_authen).to eq true
      expect(page).to have_content("Your Background Information")
    end    
  end  
  describe "sign up through google plus" do
    before do
      mock_auth_hash_googleplus
    end
    it "should create Broker and be at the first register page" do
      expect{click_link "google_plus"}.to change(Broker, :count).by(1)
      expect(Broker.first.email_authen).to eq true
      expect(page).to have_content("Your Background Information")
    end    
    describe "when username, password and password confirmation is not entered" do
      before do
        click_link "google_plus"
        fill_in "broker_username", with:""
        fill_in "broker_password", with:""
        fill_in "broker_password_confirmation", with:""
        click_button "Next"
      end
      it "should render error for each one" do
        expect(page).to have_content("Username can't be blank")
        expect(page).to have_content("Password can't be blank")
        expect(page).to have_content("Password confirmation can't be blank")
       
      end
    end
  end   
end
describe "broker social media sign in when setup is not completed" do
  before do
    extend OmniauthMacros
    OmniAuth.config.test_mode = true
    @broker=FactoryGirl.create(:complete_broker)
    @broker.username="antoniojha"
    @broker.email="antoniojha@gmail.com"
    @broker.uid="123545"
    @broker.save
    @broker.reload
    visit broker_login_path
  end  
  describe "when signing in through twitter" do
    before do
      mock_auth_hash_twitter 
      @broker.provider="twitter"
      @broker.save
    end
    it "should be at the first register page without creating a new Broker" do
      expect{click_link "twitter"}.to change(Broker, :count).by(0)
      expect(page).to have_content("Your Background Information")
    end      
  end
  describe "when signing in through linkedin" do
    before do
      mock_auth_hash_linkedin
      @broker.provider="linkedin"
      @broker.save
    end
    it "should be at the first register page without creating a new Broker" do
      expect{click_link "linkedin"}.to change(Broker, :count).by(0)
      expect(page).to have_content("Your Background Information")
    end      
  end
  describe "when signing in through facebook" do
    before do
      mock_auth_hash_facebook
      @broker.provider="facebook"
      @broker.save
    end
    it "should be at the first register page without creating a new Broker" do
      expect{click_link "facebook"}.to change(Broker, :count).by(0)
      expect(page).to have_content("Your Background Information")
    end      
  end
  describe "when signing in through googleplus" do
    before do
      mock_auth_hash_googleplus 
      @broker.provider="google_oauth2"
      @broker.save
    end
    it "should be at the first register page without creating a new Broker" do
      expect{click_link "google_plus"}.to change(Broker, :count).by(0)
      expect(page).to have_content("Your Background Information")
    end      
  end  
end
describe "broker social media sign in when setup is completed" do
  before do
    extend OmniauthMacros
    OmniAuth.config.test_mode = true
    create_complete_broker
    @broker.username="antoniojha"
    @broker.email="antoniojha@gmail.com"
    @broker.uid="123545"
    @broker.save
    @broker.reload
    visit broker_login_path
  end
  it "check broker count" do
    expect(Broker.count).to eq 1
  end
  describe "sign in through twitter" do
    before do
      @broker.provider="twitter"
      @broker.save
      @broker.reload
      mock_auth_hash_twitter 
    end
    it "should be at the first register page" do
      expect{click_link "twitter"}.to change(Broker, :count).by(0)
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
    end
  end

  describe "sign in through linkedin" do
    before do
      @broker.provider="linkedin"
      @broker.save
      @broker.reload
      mock_auth_hash_linkedin 
    end
    it "should be at the first register page" do
      expect{click_link "linkedin"}.to change(Broker, :count).by(0)
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
    end    
  end
  describe "sign in through facebook" do
    before do
      @broker.provider="facebook"
      @broker.save
      @broker.reload
      mock_auth_hash_facebook
    end
    it "should be at the first register page" do
      expect{click_link "facebook"}.to change(Broker, :count).by(0)
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
    end    
  end  
  describe "sign in through google plus" do
    before do
      @broker.provider="google_oauth2"
      @broker.save
      @broker.reload
      mock_auth_hash_googleplus 
    end
    it "should be at the first register page" do
      expect{click_link "google_plus"}.to change(Broker, :count).by(0)
      expect(page.title).to eq "RichRly|Broker Profile|Personal"
    end    
  end   

end
