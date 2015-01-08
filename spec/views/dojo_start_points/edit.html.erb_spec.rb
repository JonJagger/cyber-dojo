require 'rails_helper'

RSpec.describe "dojo_start_points/edit", :type => :view do
  before(:each) do
    @dojo_start_point = assign(:dojo_start_point, DojoStartPoint.create!(
      :dojo_id => "MyString",
      :language => "MyString",
      :exercise => "MyString"
    ))
  end

  it "renders the edit dojo_start_point form" do
    render

    assert_select "form[action=?][method=?]", dojo_start_point_path(@dojo_start_point), "post" do

      assert_select "input#dojo_start_point_dojo_id[name=?]", "dojo_start_point[dojo_id]"

      assert_select "input#dojo_start_point_language[name=?]", "dojo_start_point[language]"

      assert_select "input#dojo_start_point_exercise[name=?]", "dojo_start_point[exercise]"
    end
  end
end
