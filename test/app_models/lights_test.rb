#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class LightsTests < ModelTestBase

  test 'lights initially empty' do
    kata = make_kata
    lights = kata.start_avatar.lights
    assert_equal [ ], lights.to_a
    assert_equal 0, lights.count
    n = 0
    lights.each { n += 1 }
    assert_equal 0, n
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'lights not empty' do
    kata = make_kata
    avatar = kata.start_avatar
    incs =
    [
      red={
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      amber={
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      green={
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 55, 7],
        'number' => 3
      }
    ]
    avatar.dir.write('increments.json', incs)
    lights = avatar.lights
    assert_equal 3, lights.count

    assert_equal_light(Tag.new(avatar,red  ), lights[0])
    assert_equal_light(Tag.new(avatar,amber), lights[1])
    assert_equal_light(Tag.new(avatar,green), lights[2])

    n = 0
    lights.each { |light|
      n += 1
      assert_equal avatar, light.avatar
    }
    assert_equal 3, n

    assert_equal 3, lights.to_a.length

    a = lights.to_a
    assert_equal 'Array', a.class.name
    assert_equal 'Tag', a[0].class.name

  end

  #- - - - - - - - - - - - - - - - - - -

  def assert_equal_light(expected, actual)
    assert_equal expected.colour, actual.colour, '.colour'
    assert_equal expected.time, actual.time, '.time'
    assert_equal expected.number, actual.number, '.number'
  end

end
