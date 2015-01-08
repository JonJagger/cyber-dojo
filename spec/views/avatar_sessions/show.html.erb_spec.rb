require 'rails_helper'

RSpec.describe "avatar_sessions/show", :type => :view do
  before(:each) do
    @avatar_session = assign(:avatar_session, AvatarSession.create!(
      :avatar => "Avatar",
      :vote_count => 1,
      :fork_count => 2,
      :dojo_start_point => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Avatar/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
