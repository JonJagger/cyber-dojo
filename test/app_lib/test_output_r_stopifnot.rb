#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class OutputRStopIfNotTests < CyberDojoTestBase

  test 'ran but failed 42 is red' do
    output =
    [
      'Error: 42 == answer() is not TRUE',
      'Execution halted'
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'ran but failed 43 is red' do
    output =
    [
      'Error: 43 == answer() is not TRUE',
      'Execution halted'
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error is amber' do
    output =
    [
      ":Error: object 'sss' not found",
      'Execution halted'
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'sourced filename does not exist is amber' do
    output =
    [
      'Error in file(filename, "r", encoding = encoding) : ',
      '  cannot open the connection',
      'Calls: source -> file',
      'In addition: Warning message:',
      'In file(filename, "r", encoding = encoding) :',
      "  cannot open file 'shiker.R': No such file or directory",
      'Execution halted',
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'ran and passed is green' do
    output = '[1] "All tests passed"'
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_rstopifnot(output)
  end

end
