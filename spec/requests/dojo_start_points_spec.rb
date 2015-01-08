require 'rails_helper'

RSpec.describe "DojoStartPoints", :type => :request do
  describe "GET /dojo_start_points" do
    it "works! (now write some real specs)" do
      get dojo_start_points_path
      expect(response).to have_http_status(200)
    end
  end
end
