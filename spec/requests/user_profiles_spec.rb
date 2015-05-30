require 'rails_helper'

describe "testing whether there is a distinction between private and public profile" do
  describe "Login in as user and access user 2 page" do
    before do 
      @user=FactoryGirl.create(:user)
      @user2=@user.dup
      @user2.first_name="other_first_name"
      @user2.last_name="other_last_name"
      @user2.username="other_username"
      @user2.email="otheremail@example.com"
      @user2.save
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
    describe "should be able to upload picture" do
      before do
        visit user_path(@user)
        # rspec can't test modal form pop-up so the below line is not necessary
       # click_button "Upload Photo"
        attach_file("user_picture",Rails.root+"spec/fixtures/images/Ruby_on_Rails.jpg")
      end
      it "should show modal form to upload picture once Upload Picture button is clicked" do
        expect(@user.picture_file_name).to eq nil
        click_button "Post Picture"
        @user.reload
        expect(@user.picture_file_name).not_to eq nil
      end
      describe "after posting picture" do
        before{click_button "Post Picture"}
        it "should now have an Change Photo button instead of Upload Button" do
          expect(page).not_to have_content("Upload Photo")
          expect(page).to have_content("Change Photo")
          
        end
        
      end
    end
  end
end
