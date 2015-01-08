require 'rails_helper'

RSpec.describe "AvatarSessions", :type => :request do
  describe "GET /avatar_sessions" do
    it "works! (now write some real specs)" do
      get avatar_sessions_path
      expect(response).to have_http_status(200)
    end
  end
end
