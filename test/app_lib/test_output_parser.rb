#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'OutputParser'

class OutputParserTests < CyberDojoTestBase

  test 'terminated by the server after n seconds is amber' do
    [1,5,10].each do |n|
      assert_equal 'amber', OutputParser::colour('ignored', terminated(n))
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'when not terminated unit_test_framework selects parser' do
    output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, " +
        "expecting keyword_do or '{' or '('"
      ].join("\n")
    assert_equal 'amber', OutputParser::colour('ruby_test_unit', output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def terminated(n)
    "Terminated by the cyber-dojo server after #{n} seconds"
  end

end

# If a player creates a cyberdojo.sh file which runs two
# test files then it's possible the first one will pass and
# the second one will have a failure.
# The tests below could be improved...
# Each language+test_framework test file will be data-driven
# an array of green output
# an array of red output, and
# an array of amber output.
# Then the tests should verify that each has its correct
# colour individually, and also that
# any amber + any red => amber
# any amber + any green => amber
# any green + any red => red
