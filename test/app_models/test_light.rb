#!/usr/bin/env ruby

require_relative 'model_test_base'

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
    assert_equal year, time.year, 'year'
    assert_equal month, time.month, 'month'
    assert_equal day, time.day, 'day'
    assert_equal hh, time.hour, 'hour'
    assert_equal mm, time.min, 'min'
    assert_equal ss, time.sec, 'sec'
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

  test 'tag' do
    set_runner_class_name('StubTestRunner')
    kata = make_kata
    lion = kata.start_avatar(['lion'])    
    stub_test(lion, [:red,:green,:green])
    lights = lion.lights
    assert_equal 3, lights.length
    light = lights[2]
    assert_equal :green, light.colour
    tag = light.tag
    #assert_equal output, tag.output
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - -
  
  def stub_test(avatar,colours)
    # The output tests have been restructured so all the outputs
    # for all languages are held in one object/directory which 
    # can be queried to access with a key of [language,colour]
    # Two kinds of query: 
    #   get all matches (for the output tests themselves) REFACTOR test_output.rb
    #   get one random match (for stubbing - here)
    # 
    root = File.expand_path(File.dirname(__FILE__) + '/..') + '/app_lib/test_output'    
    colours.each do |colour|    
      path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{colour}"
      all_outputs = disk[path].each_file.collect{|filename| filename}
      filename = all_outputs.shuffle[0]
      output = disk[path].read(filename)
      dojo.runner.stub(output)      
      delta = { :changed => [], :new => [], :deleted => [] }
      files = { }
      avatar.test(delta,files)
    end
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - -

  def make_light(rgb,time,n, key='colour')
    Light.new(dummy_avatar, {
      key => rgb.to_sym,
      'time' => time,
      'number' => n
    })
  end

  def dummy_avatar
    Object.new
  end

  def dojo
    @dojo ||= Dojo.new
  end
  
  def disk
    dojo.disk
  end

end
