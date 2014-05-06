require File.dirname(__FILE__) + '/../test_helper'
require 'pie_chart_helper'

class PieChartTests < ActionView::TestCase

  include PieChartHelper

  test "pie-chart counts lights if counts not provided" do
    lights = [
      { 'colour' => 'red' },
      { 'colour' => 'red' },
      { 'colour' => 'amber' },
      { 'colour' => 'amber' },
      { 'colour' => 'green' }
    ]
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='2'" +
      " data-amber-count='2'" +
      " data-green-count='1'" +
      " width='45'" +
      " height='45'>" +
      "</canvas>"
    actual = pie_chart(lights, 45)
    assert_equal expected, actual
  end

  test "pie-chart uses counts if provides" do
    lights = [
      { 'colour' => 'red' },
      { 'colour' => 'red' },
      { 'colour' => 'amber' },
      { 'colour' => 'amber' },
      { 'colour' => 'green' }
    ]
    counts = {
      'red' => 5,
      'amber' => 0,
      'green' => 6
    }
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='5'" +
      " data-amber-count='0'" +
      " data-green-count='6'" +
      " width='42'" +
      " height='42'>" +
      "</canvas>"
    actual = pie_chart(lights, 42, counts)
    assert_equal expected, actual
  end

end
