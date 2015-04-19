#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputTests < AppLibTestBase

  test 'all saved TestRunner outputs are correctly coloured red/amber/green' do
    root = test_output_path
    disk[root].each_dir do |unit_test_framework|
      ['red','amber','green'].each do |colour|
        path = "#{root}/#{unit_test_framework}/#{colour}"
        dir = disk[path]
        dir.each_file do |filename|
          expected = colour.to_sym
          method_name = 'parse_' + unit_test_framework
          output = dir.read(filename)
          actual = OutputParser.send(method_name, output)
          diagnostic = '' +
            "OutputParser::parse_#{unit_test_framework}(output)\n" +
            "  output read from: #{root}/#{unit_test_framework}/#{colour}/#{filename}\n"
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
    set_runner_class_name('StubTestRunner')
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

  def test_output_path
    File.expand_path(File.dirname(__FILE__)) + '/test_output'    
  end  

end
