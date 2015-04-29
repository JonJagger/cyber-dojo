#!/usr/bin/env ../test_wrapper.sh app/helpers

require_relative 'app_helpers_test_base'

class PieChartTests < AppHelpersTestBase

  include PieChartHelper

  test 'pie-chart from avatar.lights' do
    set_runner_class_name('DummyTestRunner')
    kata = katas['123456789A']
    lion = kata.avatars['lion']
    lion.dir.write('increments.json', [
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      }
      ])

    size = 30
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='1'" +
      " data-amber-count='0'" +
      " data-green-count='1'" +
      " data-timed-out-count='0'" +
      " data-key='lion'" +
      " width='#{size}'" +
      " height='#{size}'>" +
      "</canvas>"

    actual = pie_chart(lion.lights, 'lion')

    assert_equal expected, actual
  end
  
  #- - - - - - - - - - - - - - - - - - - -

  test 'pie-chart from traffic-lights' do
    lights = [
      red_light,
      red_light,
      amber_light,
      amber_light,
      green_light,
      timed_out_light,
    ]
    size = 30
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='2'" +
      " data-amber-count='2'" +
      " data-green-count='1'" +
      " data-timed-out-count='1'" +
      " data-key='alligator'" +
      " width='#{size}'" +
      " height='#{size}'>" +
      "</canvas>"
    actual = pie_chart(lights, 'alligator')
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'pie-chart from counts' do
    counts = {
      :red => 5,
      :amber => 0,
      :green => 6,
      :timed_out => 1
    }
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='5'" +
      " data-amber-count='0'" +
      " data-green-count='6'" +
      " data-timed-out-count='1'" +
      " data-key='lion'" +
      " width='42'" +
      " height='42'>" +
      "</canvas>"
    actual = pie_chart_from_counts(counts, 42, 'lion')
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - -

  def   red_light; Light.new(nil,{'colour'=> :red  }); end
  def amber_light; Light.new(nil,{'colour'=> :amber}); end
  def green_light; Light.new(nil,{'colour'=> :green}); end
  def timed_out_light; Light.new(nil,{'colour'=> :timed_out}); end

end
