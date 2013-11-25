require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class StubKata
  
  def initialize(id)
    @id = id
  end
  
  def id
    @id
  end
  
end

class TrafficLightTests < ActionView::TestCase

  include TrafficLightHelper
    
  test "linked_traffic_light" do
    kata = StubKata.new(id=5335)
    avatar_name = 'lion'
    inc = make_inc
    inc[:colour] = :red
    tag = 45
    inc[:number] = tag
    inc[:revert_tag] = nil
    in_new_window = false
    html = linked_traffic_light(kata, avatar_name, inc, in_new_window)
    assert html.start_with?("<a "), '<a :' + html
    assert html.match("href=\"/diff/show/#{id}"), 'href: ' + html
    assert html.match("title=\"Show #{avatar_name}'s diff #{tag-1} -&gt; #{tag}"), 'title: ' + html
    assert html.match("src='/images/traffic_light_red.png"), 'src: ' + html
    assert html.match("alt='red traffic-light'"), 'alt: ' + html
    assert html.match("width='20'"), 'width: ' + html
    assert html.match("height='62'"), 'height: ' + html
  end

  test "traffic_light_image" do
    colour = 'red'
    width = 44
    height = 34
    actual = traffic_light_image(colour, width, height)
    assert actual.start_with? '<img '
    assert actual.match "src='/images/traffic_light_#{colour}.png'"
    assert actual.match "alt='#{colour} traffic-light'"
    assert actual.match "width='#{width}'"
    assert actual.match "height='#{height}'"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "unlinked traffic light red" do
    inc = make_inc
    inc[:colour] = :red
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic_light_red.png' alt='red traffic-light' width='20' height='62'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light amber" do
    inc = make_inc
    inc[:colour] = :amber
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic_light_amber.png' alt='amber traffic-light' width='20' height='62'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light green" do
    inc = make_inc
    inc[:colour] = :green
    expected =
      "<span title='2012 May 1, 23:20:45'>" +
      "<img src='/images/traffic_light_green.png' alt='green traffic-light' width='20' height='62'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "tool tip" do
    assert_equal "Show hippo's diff 1 -> 2 (2012 May 1, 23:20:45)",
      tool_tip('hippo', make_inc)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def width
    18
  end
  
  def height
    55
  end
  
  def make_inc
    { :number => 2, :time => [2012,5,1,23,20,45], :colour => :red }
  end
  
end
