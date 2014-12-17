require "rails_helper"

RSpec.describe SpendingsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/spendings").to route_to("spendings#index")
    end

    it "routes to #new" do
      expect(:get => "/spendings/new").to route_to("spendings#new")
    end

    it "routes to #show" do
      expect(:get => "/spendings/1").to route_to("spendings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/spendings/1/edit").to route_to("spendings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/spendings").to route_to("spendings#create")
    end

    it "routes to #update" do
      expect(:put => "/spendings/1").to route_to("spendings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/spendings/1").to route_to("spendings#destroy", :id => "1")
    end

  end
end
