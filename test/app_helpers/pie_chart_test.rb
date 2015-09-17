#!/bin/bash ../test_wrapper.sh

require_relative 'AppHelpersTestBase'

class PieChartTests < AppHelpersTestBase

  include PieChartHelper

  test '10E59E',
  'pie-chart from avatar.lights' do
    set_disk_class('DiskStub')
    kata = make_kata
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

    size = 27
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

  test '3AF953',
  'pie-chart from lights' do
    lights = [
      red_light,
      red_light,
      amber_light,
      amber_light,
      green_light,
      timed_out_light,
    ]
    size = 27
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

  test '490C54',
  'pie-chart from counts' do
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

  def   red_light; Tag.new(nil,{'colour'=> :red  }); end
  def amber_light; Tag.new(nil,{'colour'=> :amber}); end
  def green_light; Tag.new(nil,{'colour'=> :green}); end
  def timed_out_light; Tag.new(nil,{'colour'=> :timed_out}); end

end
