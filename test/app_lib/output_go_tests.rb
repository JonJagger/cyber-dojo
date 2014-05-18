#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../cyberdojo_test_base'
require 'OutputParser'

class OutputGoTests < CyberDojoTestBase

  test 'build failed is amber' do
    assert_equal :amber, colour_of("[build failed]")
  end

  test 'ran but failed is green' do
    assert_equal :red, colour_of("FAIL")
  end

  test 'ran and passed is red' do
    assert_equal :green, colour_of("PASS")
  end

  test 'anything else is amber' do
    assert_equal :amber, colour_of("anything else")
  end

  def colour_of(output)
    OutputParser::parse_go_testing(output)
  end

end
