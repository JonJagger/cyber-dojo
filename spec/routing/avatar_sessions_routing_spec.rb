require "rails_helper"

RSpec.describe AvatarSessionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/avatar_sessions").to route_to("avatar_sessions#index")
    end

    it "routes to #new" do
      expect(:get => "/avatar_sessions/new").to route_to("avatar_sessions#new")
    end

    it "routes to #show" do
      expect(:get => "/avatar_sessions/1").to route_to("avatar_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/avatar_sessions/1/edit").to route_to("avatar_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/avatar_sessions").to route_to("avatar_sessions#create")
    end

    it "routes to #update" do
      expect(:put => "/avatar_sessions/1").to route_to("avatar_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/avatar_sessions/1").to route_to("avatar_sessions#destroy", :id => "1")
    end

  end
end
