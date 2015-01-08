require 'rails_helper'

RSpec.describe "traffic_lights/show", :type => :view do
  before(:each) do
    @traffic_light = assign(:traffic_light, TrafficLight.create!(
      :tag => 1,
      :content_hash => "Content Hash",
      :fork_count => 2,
      :AvatarSession => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Content Hash/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
