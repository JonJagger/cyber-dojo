#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputTests < AppLibTestBase

  test 'red/amber/green cases for all language.unit_test_framework entries' do
    root = File.expand_path(File.dirname(__FILE__)) + '/test_output'
    Disk.new[root].each_dir do |unit_test_framework|
      ['red','amber','green'].each do |colour|
        path = "#{root}/#{unit_test_framework}/#{colour}"
        dir = Disk.new[path]
        dir.each_file do |filename|
          output = dir.read(filename)
          method_name = 'parse_' + unit_test_framework
          expected = colour.to_sym
          actual = OutputParser.send(method_name, output)
          diagnostic = '' +
            "OutputParser::parse_#{unit_test_framework}(output)\n" +
            "  output from: .../test/app_lib/test_output/#{colour}/#{filename}\n"
          assert_equal expected, actual, diagnostic
        end
      end
    end    
  end
  
end
