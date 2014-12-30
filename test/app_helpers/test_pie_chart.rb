#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class PieChartTests < CyberDojoTestBase

  include PieChartHelper

  test 'pie-chart from avatar.lights' do
    thread[:disk] = DiskFake.new
    thread[:git] = Object.new
    thread[:runner] = Object.new
    @dojo = Dojo.new(root_path)
    kata = @dojo.katas['123456789A']
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

    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='1'" +
      " data-amber-count='0'" +
      " data-green-count='1'" +
      " data-timed-out-count='0'" +
      " data-key='lion'" +
      " width='40'" +
      " height='40'>" +
      "</canvas>"

    actual = pie_chart(lion.lights, 40, 'lion')

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
    expected = "" +
      "<canvas" +
      " class='pie'" +
      " data-red-count='2'" +
      " data-amber-count='2'" +
      " data-green-count='1'" +
      " data-timed-out-count='1'" +
      " data-key='alligator'" +
      " width='45'" +
      " height='45'>" +
      "</canvas>"
    actual = pie_chart(lights, 45, 'alligator')
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
