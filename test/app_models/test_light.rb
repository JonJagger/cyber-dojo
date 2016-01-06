#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'
require_relative './delta_maker'

class LightTests < AppModelTestBase

  test 'AC96D0',
  'colour is converted to a symbol' do
    light = make_light(:red, [2015, 2, 15, 8, 54, 6], 1)
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'B136BD',
  'colour was once stored as outcome' do
    light = make_light(:red, [2015, 2, 15, 8, 54, 6], 1, 'outcome')
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'B09D76',
  'time is read back as set' do
    year = 2015
    month = 2
    day = 15
    hh = 8
    mm = 54
    ss = 6
    light = make_light(:red, [year, month, day, hh, mm, ss], 1)
    time = light.time
    assert_equal year,  time.year,  'year'
    assert_equal month, time.month, 'month'
    assert_equal day,   time.day,   'day'
    assert_equal hh,    time.hour,  'hour'
    assert_equal mm,    time.min,   'min'
    assert_equal ss,    time.sec,   'sec'
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'ED8954',
  'number is read as set' do
    number = 7
    light = make_light(:red, [2015, 2, 15, 8, 54, 6], number)
    assert_equal number, light.number
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '21DAC8',
  'to_json' do
    colour = :red
    time = [2015, 2, 15, 8, 54, 6]
    number = 7
    light = make_light(colour, time, number)
    assert_equal({
      'colour' => colour,
      'time'   => Time.mktime(*time),
      'number' => number
    }, light.to_json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '8BE722',
  'each test creates a new light' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    maker = DeltaMaker.new(lion)
    runner.stub_run_colour(lion, :red)
    maker.run_test
    runner.stub_run_colour(lion, :amber)
    maker.run_test
    runner.stub_run_colour(lion, :green)
    maker.run_test
    lights = lion.lights
    assert_equal 3, lights.length
    assert_equal :red,   lights[0].colour
    assert_equal :amber, lights[1].colour
    assert_equal :green, lights[2].colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  private

  def make_light(rgb, time, n, key = 'colour')
    Tag.new(dummy_avatar, {
      key      => rgb.to_sym,
      'time'   => time,
      'number' => n
    })
  end

  def dummy_avatar
    Object.new
  end

end
