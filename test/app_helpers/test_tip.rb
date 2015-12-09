#!/bin/bash ../test_wrapper.sh

require_relative './app_helpers_test_base'
require_relative './../app_models/delta_maker'

class TipTests < AppHelpersTestBase

  include TipHelper

  def setup
    super
    set_one_self_class 'OneSelfDummy'
  end

  #- - - - - - - - - - - - - - - - - -

  test 'FAE414',
  'traffic light count tip includes time-out when there is a time-out' do
    params = {
               'avatar' => 'lion',
       'current_colour' => 'red',
            'red_count' => 14,
          'amber_count' => 3,
          'green_count' => 5,
      'timed_out_count' => 1,
           'bulb_count' => 23
    }
    expected =
      'lion has 23 traffic-lights<br/>' +
      "<div>&bull; 14 <span class='red'>reds</span></div>" +
      "<div>&bull; 3 <span class='amber'>ambers</span></div>" +
      "<div>&bull; 5 <span class='green'>greens</span></div>" +
      "<div>&bull; 1 <span class='timed_out'>timeout</span></div>"
    actual = traffic_light_count_tip_html(params)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - -

  test 'C2A9CD',
  'traffic light count tip excludes time-out when there are no time-outs' do
    params = {
               'avatar' => 'lion',
       'current_colour' => 'red',
            'red_count' => 14,
          'amber_count' => 3,
          'green_count' => 5,
      'timed_out_count' => 0,
           'bulb_count' => 22
    }
    expected =
      'lion has 22 traffic-lights<br/>' +
      "<div>&bull; 14 <span class='red'>reds</span></div>" +
      "<div>&bull; 3 <span class='amber'>ambers</span></div>" +
      "<div>&bull; 5 <span class='green'>greens</span></div>"
    actual = traffic_light_count_tip_html(params)
    assert_equal expected, actual
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
      "Click to review lion's " +
      "<span class='#{was_tag_colour}'>#{was_tag}</span> " +
      "&harr; " +
      "<span class='#{now_tag_colour}'>#{now_tag}</span> diff" +
      "<div>&bull; 1 added line</div>" +
      "<div>&bull; 1 deleted line</div>"
    actual = traffic_light_tip_html(lion, was_tag, now_tag)
    assert_equal expected, actual
  end

end
