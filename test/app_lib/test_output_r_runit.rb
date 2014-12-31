#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputRUnitTests < AppLibTestBase

  test 'checkEquals fails is red' do
    output =
    [
      'Loading required package: methods',
      'Error in checkEquals(42, answer()) : Mean relative difference: 0.2857143',
      'Execution halted'
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'checkTrue fails is red' do
    output =
    [
      'Loading required package: methods',
      'Error in checkTrue(42 == 41) : Test not TRUE',
      'Execution halted',
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error is amber' do
    output =
    [
      "Error: object 'sss' not found",
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
    OutputParser::parse_runit(output)
  end

end
