#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'
require_relative 'DeltaMaker'

class LightTests < ModelTestBase

  test 'colour is converted to a symbol' do
    light = make_light(:red,[2015,2,15,8,54,6],1)
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'colour was once stored as outcome' do
    light = make_light(:red,[2015,2,15,8,54,6],1,'outcome')
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'time is read back as set' do
    year,month,day,hh,mm,ss = 2015,2,15,8,54,6
    light = make_light(:red,[year,month,day,hh,mm,ss],1)
    time = light.time
    assert_equal year,  time.year,  'year'
    assert_equal month, time.month, 'month'
    assert_equal day,   time.day,   'day'
    assert_equal hh,    time.hour,  'hour'
    assert_equal mm,    time.min,   'min'
    assert_equal ss,    time.sec,   'sec'
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'number is read as set' do
    number = 7
    light = make_light(:red,[2015,2,15,8,54,6],number)
    assert_equal number, light.number
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'to_json' do
    colour = :red
    time = [2015,2,15,8,54,6]
    number = 7
    light = make_light(colour,time,number)
    assert_equal({
      'colour' => colour,
      'time' => Time.mktime(*time),
      'number' => number
    }, light.to_json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'each test creates a new light' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])    
    maker = DeltaMaker.new(lion)
    runner.stub_output('xxxxx')
    maker.run_test
    maker.run_test
    maker.run_test
    lights = lion.lights
    assert_equal 3, lights.length
    assert_equal :amber, lights[0].colour    # TODO :red
    assert_equal :amber, lights[1].colour
    assert_equal :amber, lights[2].colour    # TODO :green
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - -
  
  def make_light(rgb, time, n, key = 'colour')
    Tag.new(dummy_avatar, {
      key => rgb.to_sym,
      'time' => time,
      'number' => n
    })
  end

  def dummy_avatar
    Object.new
  end

end
