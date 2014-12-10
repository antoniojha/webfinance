require 'rails_helper'

RSpec.describe SessionsHelper, :type => :helper do
  before do
    @user=FactoryGirl.create(:user)
    remember(@user)
  end
  describe "testing current_user method" do
    it "current user returns right user when session is nil" do
      expect(@user).to eq(current_user)
      expect(logged_in?).to eq(true)
    end
    it "current user returns nil when auth_token digest is wrong" do
      @user.update_attribute(:auth_token_digest,  User.digest(""))
      expect(current_user).to eq(nil)
    end
  end
end
