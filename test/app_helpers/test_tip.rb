#!/bin/bash ../test_wrapper.sh

require_relative './app_helpers_test_base'
require_relative './../app_models/delta_maker'

class TipTests < AppHelpersTestBase

  include TipHelper

  def setup
    super
  end

  #- - - - - - - - - - - - - - - - - -

  test 'BDAD52',
  'traffic light tip' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    maker = DeltaMaker.new(lion)

    maker.stub_colour(:red)
    maker.run_test

    filename = 'hiker.c'
    assert maker.file?(filename)
    content = maker.content(filename)
    refute_nil content
    maker.change_file(filename, content.sub('9', '7'))
    maker.stub_colour(:green)
    maker.run_test

    was_tag = 1
    was_tag_colour = 'red'
    now_tag = 2
    now_tag_colour = 'green'
    expected =
      "Click to review lion's<br/>" +
      "<span class='#{was_tag_colour}'>#{was_tag}</span> " +
      "&harr; " +
      "<span class='#{now_tag_colour}'>#{now_tag}</span> diff" +
      "<div>1 added line</div>" +
      "<div>1 deleted line</div>"
    actual = traffic_light_tip_html(lion, was_tag, now_tag)
    assert_equal expected, actual
  end

end
