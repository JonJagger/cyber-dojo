require "rails_helper"

RSpec.describe DojoStartPointsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dojo_start_points").to route_to("dojo_start_points#index")
    end

    it "routes to #new" do
      expect(:get => "/dojo_start_points/new").to route_to("dojo_start_points#new")
    end

    it "routes to #show" do
      expect(:get => "/dojo_start_points/1").to route_to("dojo_start_points#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dojo_start_points/1/edit").to route_to("dojo_start_points#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dojo_start_points").to route_to("dojo_start_points#create")
    end

    it "routes to #update" do
      expect(:put => "/dojo_start_points/1").to route_to("dojo_start_points#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dojo_start_points/1").to route_to("dojo_start_points#destroy", :id => "1")
    end

  end
end
