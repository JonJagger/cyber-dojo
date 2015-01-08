require 'rails_helper'

RSpec.describe "avatar_sessions/edit", :type => :view do
  before(:each) do
    @avatar_session = assign(:avatar_session, AvatarSession.create!(
      :avatar => "MyString",
      :vote_count => 1,
      :fork_count => 1,
      :dojo_start_point => nil
    ))
  end

  it "renders the edit avatar_session form" do
    render

    assert_select "form[action=?][method=?]", avatar_session_path(@avatar_session), "post" do

      assert_select "input#avatar_session_avatar[name=?]", "avatar_session[avatar]"

      assert_select "input#avatar_session_vote_count[name=?]", "avatar_session[vote_count]"

      assert_select "input#avatar_session_fork_count[name=?]", "avatar_session[fork_count]"

      assert_select "input#avatar_session_dojo_start_point_id[name=?]", "avatar_session[dojo_start_point_id]"
    end
  end
end
