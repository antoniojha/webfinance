require 'rails_helper'
describe " select_bank_controller" do
  before do
    user=FactoryGirl.create(:user)
  end
  it "should render error page if API query takes too long to refresh" do
    get :next_page2, :LOGIN => "login", :PASSWORD => 'password'
    params[:LOGIN].should eql "login"
  end
end