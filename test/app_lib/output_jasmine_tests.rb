# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

class OutputJasmineTests < ActionController::TestCase
  
  include CodeOutputParser

  test "one fail is red" do
    output =
      [
        "F",
        "",
        "Failures:",
        "",
        "  1) should fail",
        "   Message:",
        "    Expected 42 to equal 54.",
        "   Stacktrace:",
        "    Error: Expected 42 to equal 54.",
        "",
        "Finished in 0.029 seconds",
        "1 test, 1 assertion, 1 failure"     
      ].join("\n")
    assert_equal :red, colour_of(output)            
  end

  test "no fails and one pass is green" do
    output =
      [
        ".",
        "",
        "Finished in 0.04 seconds",
        "1 test, 1 assertion, 0 failures"
      ].join("\n")
    assert_equal :green, colour_of(output)               
  end

  test "no fails and all passes is green" do
    output =
      [
        "...",
        "",
        "Finished in 0.007 seconds",
        "3 tests, 3 assertions, 0 failures"
      ].join("\n")
    assert_equal :green, colour_of(output)                   
  end

  test "one fail and lots of passes is red" do
    output =
      [
        "..F",
        "",
        "Failures:",
        "",
        "  1) should pass 2",
        "   Message:",
        "     Expected 42 to equal 54.",
        "   Stacktrace:",
        "     Error: Expected 42 to equal 54.",
        "",
        "Finished in 0.032 seconds",
        "3 tests, 3 assertions, 1 failure"
      ].join("\n")
    assert_equal :red, colour_of(output)                       
  end

  test "syntax error of the first kind is amber" do
    output =
      [    
        "node.js:201",
        "        throw e; // process.nextTick error, or 'error' event on first tick",
        "              ^",
        "Error: In "
      ].join("\n")
    assert_equal :amber, colour_of(output)               
  end
  
  test "syntax error of the second kind is amber" do
    output =
      [      
        "node.js:201",
        "        throw e; // process.nextTick error, or 'error' event on first tick",
        "              ^",
        "SyntaxError: In"
      ].join("\n")
    assert_equal :amber, colour_of(output)               
  end
  
  def colour_of(output)
    CodeOutputParser::parse_jasmine(output) # coffee-script
  end
  
end


