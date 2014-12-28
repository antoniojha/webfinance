require 'rails_helper'

RSpec.describe "StartPlannings", :type => :request do
  describe "GET /start_plannings" do
    it "works! (now write some real specs)" do
      get start_plannings_path
      expect(response).to have_http_status(200)
    end
  end
end
