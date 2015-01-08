require 'rails_helper'

RSpec.describe "dojo_start_points/index", :type => :view do
  before(:each) do
    assign(:dojo_start_points, [
      DojoStartPoint.create!(
        :dojo_id => "Dojo",
        :language => "Language",
        :exercise => "Exercise"
      ),
      DojoStartPoint.create!(
        :dojo_id => "Dojo",
        :language => "Language",
        :exercise => "Exercise"
      )
    ])
  end

  it "renders a list of dojo_start_points" do
    render
    assert_select "tr>td", :text => "Dojo".to_s, :count => 2
    assert_select "tr>td", :text => "Language".to_s, :count => 2
    assert_select "tr>td", :text => "Exercise".to_s, :count => 2
  end
end
