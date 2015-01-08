require 'rails_helper'

RSpec.describe "avatar_sessions/new", :type => :view do
  before(:each) do
    assign(:avatar_session, AvatarSession.new(
      :avatar => "MyString",
      :vote_count => 1,
      :fork_count => 1,
      :dojo_start_point => nil
    ))
  end

  it "renders new avatar_session form" do
    render

    assert_select "form[action=?][method=?]", avatar_sessions_path, "post" do

      assert_select "input#avatar_session_avatar[name=?]", "avatar_session[avatar]"

      assert_select "input#avatar_session_vote_count[name=?]", "avatar_session[vote_count]"

      assert_select "input#avatar_session_fork_count[name=?]", "avatar_session[fork_count]"

      assert_select "input#avatar_session_dojo_start_point_id[name=?]", "avatar_session[dojo_start_point_id]"
    end
  end
end
