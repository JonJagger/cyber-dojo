#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputDUnitTestTests < AppLibTestBase

  test 'ran but failed is red' do
    assert_equal :red, colour_of("core.exception.AssertError")
  end

  test 'ran and passed is green' do
    assert_equal :green, colour_of("All tests passed")
  end

  test 'anything else is amber' do
    assert_equal :amber, colour_of("anything else")
  end

  def colour_of(output)
    OutputParser::parse_d_unittest(output)
  end

end
