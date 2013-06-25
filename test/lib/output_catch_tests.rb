# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

class OutputCatchTests < ActionController::TestCase
  
  include CodeOutputParser

  test "RED" do
    output = "[Testing completed. All 1 test(s) failed]"
    assert_equal :red, colour_of(output)
  end

  test "GREEN" do
    output = "[Testing completed. All 1 test(s) succeeded]"
    assert_equal :green, colour_of(output)
  end
  
  test "RED one pass one fail" do
    output = "[Testing completed. 1 test(s) passed but 1 test(s) failed]"
    assert_equal :red, colour_of(output)
  end
  
  test "AMBER" do
    output =
      [
        "untitled.tests.cpp: In function 'void catch_internal_TestFunction5()':",
        "untitled.tests.cpp:7: error: 'typo' was not declared in this scope",
        "untitled.tests.cpp:8: error: expected `;' before '}' token",
        "make: *** [run.tests] Error 1"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end
  
  def colour_of(output)
    CodeOutputParser::parse_catch(output)
  end
  
end


