#!/usr/bin/env ruby

require_relative 'model_test_base'

class LightTests < ModelTestBase

  test 'lights initially empty' do
    kata = make_kata
    lights = kata.start_avatar.lights
    assert_equal [], lights.entries
    assert_equal 0, lights.length
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
    avatar.dir.spy_read('increments.json', JSON.unparse(incs))
    lights = avatar.lights
    assert_equal 3, lights.length

    assert_equal_light(Light.new(avatar,red  ), lights[0])
    assert_equal_light(Light.new(avatar,amber), lights[1])
    assert_equal_light(Light.new(avatar,green), lights[2])
    assert_equal_light(Light.new(avatar,green), lights.latest)
  end

  #- - - - - - - - - - - - - - - - - - -

  def assert_equal_light(expected, actual)
    assert_equal expected.colour, actual.colour, '.colour'
    assert_equal expected.time, actual.time, '.time'
    assert_equal expected.number, actual.number, '.number'
  end
end
