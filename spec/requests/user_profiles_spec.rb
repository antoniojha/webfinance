require 'rails_helper'

describe "testing whether there is a distinction between private and public profile" do
  describe "Login in as user and access user 2 page" do
    before do 
      @user=FactoryGirl.create(:user)
      @user2=@user
      @user2.first_name="other_first_name"
      @user2.last_name="other_last_name"
      @user2.save
      @user2.reload
      log_in(@user)
    end
    it "should not display upload picture button on user2's profile page" do
      visit user_path(@user2)
      expect(page).not_to have_content("Upload Photo")
    end
    it "should display upload picture button on user's personal page" do
      visit user_path(@user)
      expect(page.title).to eq "RichRly|User Profile"
      expect(page).to have_content("Upload Photo") 
    end
    
  end
end
