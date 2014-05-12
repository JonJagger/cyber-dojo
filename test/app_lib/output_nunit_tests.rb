# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputNUnitTests < ActionController::TestCase

  include OutputParser

  test "nunit RED" do
    # There are two NUnit output formats depending on what
    # version you're using and possibly whether you're on
    # a windows box or are running on Mono
    output_1 = 'Tests run: 1, Failures: 1'
    assert_equal :red, colour_of(output_1)
    output_2 = 'Tests run: 3, Errors: 0, Failures: 3'
    assert_equal :red, colour_of(output_2)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "nunit GREEN" do
    output_1 = 'Tests run: 1, Failures: 0'
    assert_equal :green, colour_of(output_1)
    output_2 = 'Tests run: 3, Errors: 0, Failures: 0'
    assert_equal :green, colour_of(output_2)
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
