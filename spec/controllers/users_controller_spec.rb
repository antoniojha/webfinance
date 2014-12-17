require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  before do
    @user=FactoryGirl.create(:user)
    @user.update_attributes(email_authen:'true')
  end
  describe "testing authorize_login feature" do
    it "should get new" do
      get :new
      expect(flash.empty?).to eq true
      expect(response).to render_template("new")
    end
    it "should redirect edit when not logged in" do
      get :edit, :id=>@user.id
      expect(flash.empty?).to eq false
      expect(response).to redirect_to(login_url)
    end
    it "should redirect update when not logged in" do
      patch :update, :id=>@user.id, user: { username: @user.username, email: @user.email }
      expect(flash.empty?).to eq false
      expect(response).to redirect_to(login_url)
    end
  end
  describe "testing requiring right user feature" do
    before do
      @user2=FactoryGirl.create(:other_user)
      @user2.update_attributes(email_authen:'true')
      # log_in(@user2) <-- doesn't work for some reason
      session[:user_id]=@user2.id
    end
    it "should redirect edit when not the right user" do
      get :edit, :id=>@user.id
      expect(flash.empty?).to eq false
      expect(response).to redirect_to(user_url(@user2))
    end
    it "should redirect update when not the right user" do
      patch :update,:id=>@user.id,user: { username: @user.username, email: @user.email }
      expect(flash.empty?).to eq false
      expect(response).to redirect_to(user_url(@user2))
    end

    it "should redirect destroy when not the right user" do
      delete :destroy, :id=>@user.id
      expect(flash.empty?).to eq false
      expect(response).to redirect_to(user_url(@user2))      
    end
  end
end
