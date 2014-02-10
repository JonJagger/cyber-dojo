# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

# If a player creates a cyberdojo.sh file which runs two
# test files then it's possible the first one will pass and
# the second one will have a failure.
# The tests below need to be restructured, one file per
# language, and data driven. Each test file will contain
# an array of green output
# an array of red output, and
# an array of amber output.
# Then the tests should verify that each has its correct
# colour individually, and also that
# any amber + any red => amber
# any amber + any green => amber
# any green + any red => red

class CodeOutputParserTests < ActionController::TestCase
  
  include CodeOutputParser

  test "terminated by the server after 10 seconds is amber" do
    output = "Terminated by the cyber-dojo server after 10 seconds"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "terminated by the server after 5 seconds is amber" do
    output = "Terminated by the cyber-dojo server after 5 seconds"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "terminated by the server after 1 second is amber" do
    output = "Terminated by the cyber-dojo server after 1 second"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "when not terminated unit_test_framework name is used to select parser" do
    output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('"    
      ].join("\n")
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ruby_test_unit', output)        
  end
  
end


