require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  before do
    @user=FactoryGirl.create(:user)
    @user.update_attributes(email_authen:'true')
  end
  subject{@user}
  describe "testing remember me/login feature" do
    it {should respond_to(:email_confirmation_token)}
    it "should create cookies when user check remember me" do
      expect(request.cookies['user_id']).to eq (nil)
      post :create, session:{username: @user.username, password: @user.password, remember: '1'}
      response.should redirect_to @user
      expect(response.cookies['user_id']).not_to eq (nil)
    end
    it "shouldn't create cookies when user doesn't check remember me box" do
      expect(request.cookies['user_id']).to eq (nil)
      post :create, session:{username: @user.username, password: @user.password, remember: '0'}
      response.should redirect_to @user
      expect(response.cookies['user_id']).to eq (nil)    
    end
  end

end
