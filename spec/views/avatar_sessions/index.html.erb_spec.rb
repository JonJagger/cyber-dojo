require 'rails_helper'

RSpec.describe "avatar_sessions/index", :type => :view do
  before(:each) do
    assign(:avatar_sessions, [
      AvatarSession.create!(
        :avatar => "Avatar",
        :vote_count => 1,
        :fork_count => 2,
        :dojo_start_point => nil
      ),
      AvatarSession.create!(
        :avatar => "Avatar",
        :vote_count => 1,
        :fork_count => 2,
        :dojo_start_point => nil
      )
    ])
  end

  it "renders a list of avatar_sessions" do
    render
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
