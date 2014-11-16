require 'rails_helper'
describe SelectBanksController do
  before do
    user=FactoryGirl.create(:user)
  end
  it "should render error page if API query takes too long to refresh" do
#    get :next_page2
#    sleep(30)
#    response.should render_template('error_page')
#    params[:LOGIN].should eql "login"
  end
end