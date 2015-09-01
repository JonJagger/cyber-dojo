#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class OutputColourTests < AppLibTestBase

  def setup
    super
    set_runner_class_name('RunnerStub')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
  test 'terminated by the server after n seconds gives timed_out colour ' do
    [1,5,10].each do |n|
      assert_equal 'timed_out', OutputColour::of('ignored', terminated(n))
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  
  test 'all saved TestRunner outputs are correctly coloured red/amber/green' do
    root = test_output_path
    disk[root].each_dir do |unit_test_framework|
      ['red','amber','green'].each do |expected|
        path = "#{root}/#{unit_test_framework}/#{expected}"
        dir = disk[path]
        dir.each_file do |filename|
          output = dir.read(filename)
          actual = OutputColour::of(unit_test_framework, output)
          diagnostic = '' +
            "OutputColour::of(output)\n" +
            "  output read from: #{root}/#{unit_test_framework}/#{expected}/#{filename}\n"
          assert_equal expected, actual, diagnostic
        end
      end
    end    
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'all saved TestRunner outputs have red cases & amber cases & green cases' do
    root = test_output_path    
    disk[root].each_dir do |unit_test_framework|
      ['red','amber','green'].each do |colour|
        path = "#{root}/#{unit_test_framework}/#{colour}"
        diagnostic = "#{path}/ does not exist"
        assert disk[path].exists?, diagnostic
      end
    end
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'all dojo.languages have corresponding test_output/unit_test_framework' do
    set_languages_root('/var/www/cyber-dojo/languages')    
    runner.stub_runnable(true)
    root = test_output_path        
    count = 0    
    dojo.languages.each do |language|
      count += 1
      path = root + '/' + language.unit_test_framework
      diagnostic = '' +
        "language: #{language.name}\n" +
        "unit_test_framework: #{language.unit_test_framework}\n" +
        "...#{path}/ does not exist"
      assert disk[path].exists?, diagnostic
    end
    assert count > 0, "no languages"
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def terminated(n)
    "Unable to complete the test in #{n} seconds"
  end

  def test_output_path
    File.expand_path(File.dirname(__FILE__)) + '/test_output'    
  end  

end

# If a player creates a cyberdojo.sh file which runs two
# test files then it's possible the first one will pass and
# the second one will have a failure.
# The tests could be improved...
# Each language+test_framework test file will be data-driven
# an array of green output
# an array of red output, and
# an array of amber output.
# Then the tests should verify that each has its correct
# colour individually, and also that
# any amber + any red => amber
# any amber + any green => amber
# any green + any red => red

