require 'rails_helper'

RSpec.describe "TrafficLights", :type => :request do
  describe "GET /traffic_lights" do
    it "works! (now write some real specs)" do
      get traffic_lights_path
      expect(response).to have_http_status(200)
    end
  end
end
