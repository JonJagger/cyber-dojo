require 'rails_helper'

RSpec.describe "traffic_lights/index", :type => :view do
  before(:each) do
    assign(:traffic_lights, [
      TrafficLight.create!(
        :tag => 1,
        :content_hash => "Content Hash",
        :fork_count => 2,
        :AvatarSession => nil
      ),
      TrafficLight.create!(
        :tag => 1,
        :content_hash => "Content Hash",
        :fork_count => 2,
        :AvatarSession => nil
      )
    ])
  end

  it "renders a list of traffic_lights" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Content Hash".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
