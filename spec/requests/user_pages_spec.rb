require 'rails_helper'

RSpec.describe "UserEdits", :type => :request do
  describe "user edit page" do
    before do 
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit edit_user_path(@user)
    end
    describe "unsuccessful update" do

      it "should render error message" do
        fill_in "Password", :with=>"invalid"
        click_button "Update Account"
        expect(page).to have_content('error')
        expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
      end
    end
    describe "successful update" do
      it "should redirect to user/show page" do
        fill_in "Password", :with=> @user.password+'1'
        fill_in "Password confirmation", :with=> @user.password+'1'
        click_button "Update Account"
        expect(page).to have_content('User was successfully updated')
      end
    end
  end
  describe "user index page" do
    describe "as normal user" do
      before(:all){30.times{FactoryGirl.create(:all_users)}}
      after(:all){User.delete_all}
      before do
        @user1=FactoryGirl.create(:user)
        log_in(@user1)
         visit users_path
      end
      describe "pagination" do
        subject{page}
        it { should have_selector('div.pagination')}
        it "should list each user" do
          User.paginate(page:1).each do |user|
            expect(page).to have_selector(:css,'td',text:user.first_name)
          end
        end
      end
      it "should have the right elements" do
        expect(page).to have_title("WebFinance App|All Users")
        expect(page).to have_selector('h1',text:'All Users')
      end
      it "should not have delete links" do
        expect(page).not_to have_link("delete")
      end
     
    end
    describe "as an admin user" do
      let(:admin){FactoryGirl.create(:admin)}
      before do
        @user2=FactoryGirl.create(:other_user)
        log_in(admin)
        visit users_path
      end
      it "should have delete links" do
        expect(page).to have_link("delete", href:admin_remove_path(@user2))
      end
      it "should delete" do
        click_link("delete")
        fill_in "Username", with: admin.username
        fill_in "Password", with: admin.password
        expect{click_button 'Delete Profile'}.to change(User,:count).by(-1)
        expect(page.title).to eq('WebFinance App|All Users')
        expect(page).not_to have_link('delete', href:admin_remove_path(@user2))
      end
    end
  end
  describe "user remove page" do
     before do 
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit edit_user_path(@user)
      click_link ('Remove Profile')
    end
    #check
    it "should succesfully remove user if login and password is correct" do
      fill_in "Username", :with=>@user.username
      fill_in "Password", :with=>@user.password
      expect{click_button "Delete Profile"}.to change(User,:count).by(-1)
      expect(page).to have_title('WebFinance App|Login')
      expect(page).to have_selector(:css, 'div.notice',text:"Your profile is successfully removed!")
    end
    #check
    it "should display error message if login/password is incorrect" do
      fill_in "Username", :with=>@user.username
      fill_in "Password", :with=>""
      click_button "Delete Profile"
      expect(page).to have_selector(:css, 'div.alert.alert-danger',text:"Invalid user/password combinations" )
    end
  end
end
