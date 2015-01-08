require 'rails_helper'

RSpec.describe "traffic_lights/edit", :type => :view do
  before(:each) do
    @traffic_light = assign(:traffic_light, TrafficLight.create!(
      :tag => 1,
      :content_hash => "MyString",
      :fork_count => 1,
      :AvatarSession => nil
    ))
  end

  it "renders the edit traffic_light form" do
    render

    assert_select "form[action=?][method=?]", traffic_light_path(@traffic_light), "post" do

      assert_select "input#traffic_light_tag[name=?]", "traffic_light[tag]"

      assert_select "input#traffic_light_content_hash[name=?]", "traffic_light[content_hash]"

      assert_select "input#traffic_light_fork_count[name=?]", "traffic_light[fork_count]"

      assert_select "input#traffic_light_AvatarSession_id[name=?]", "traffic_light[AvatarSession_id]"
    end
  end
end
