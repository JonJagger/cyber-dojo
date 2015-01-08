require 'rails_helper'

RSpec.describe "dojo_start_points/show", :type => :view do
  before(:each) do
    @dojo_start_point = assign(:dojo_start_point, DojoStartPoint.create!(
      :dojo_id => "Dojo",
      :language => "Language",
      :exercise => "Exercise"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Dojo/)
    expect(rendered).to match(/Language/)
    expect(rendered).to match(/Exercise/)
  end
end
