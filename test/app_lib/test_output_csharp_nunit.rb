#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputNUnitTests < AppLibTestBase

  test "nunit RED" do
    output = 'Errors and Failures:'
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "nunit GREEN" do
    output = 'Tests run: 3, Errors: 0, Failures: 0'
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "nunit AMBER" do
    output = 'error CS1525: Unexpected symbol ss'
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_nunit(output)
  end

end
