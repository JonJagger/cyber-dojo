require "rails_helper"

RSpec.describe TrafficLightsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/traffic_lights").to route_to("traffic_lights#index")
    end

    it "routes to #new" do
      expect(:get => "/traffic_lights/new").to route_to("traffic_lights#new")
    end

    it "routes to #show" do
      expect(:get => "/traffic_lights/1").to route_to("traffic_lights#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/traffic_lights/1/edit").to route_to("traffic_lights#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/traffic_lights").to route_to("traffic_lights#create")
    end

    it "routes to #update" do
      expect(:put => "/traffic_lights/1").to route_to("traffic_lights#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/traffic_lights/1").to route_to("traffic_lights#destroy", :id => "1")
    end

  end
end
