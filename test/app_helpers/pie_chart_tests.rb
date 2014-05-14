require File.dirname(__FILE__) + '/../test_helper'
require 'pie_chart_helper'

class PieChartTests < ActionView::TestCase

  include PieChartHelper

  test "pie-chart from traffic-lights" do
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
      " data-key='alligator'" +
      " width='45'" +
      " height='45'>" +
      "</canvas>"
    actual = pie_chart(lights, 45, 'alligator')
    assert_equal expected, actual
  end

  test "pie-chart from counts" do
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
      " data-key='lion'" +
      " width='42'" +
      " height='42'>" +
      "</canvas>"
    actual = pie_chart_from_counts(counts, 42,'lion')
    assert_equal expected, actual
  end

end
