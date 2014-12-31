#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputFortranFUnitTestTests < AppLibTestBase

  test 'ran but failed is red' do
    output =
    [
      '==========[ SUMMARY ]==========',
      ' hiker_class:  failed   <<<<<',
      '',
      'STOP 1'
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'ran but failed with different class name is red' do
    output =
    [
      '==========[ SUMMARY ]==========',
      ' wibble_class:  failed   <<<<<',
      '',
      'STOP 1'
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'ran and passed is green' do
    output =
    [
      '==========[ SUMMARY ]==========',
      ' hiker_class:  passed'
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'ran and passed with different class name is green' do
    output =
    [
      '==========[ SUMMARY ]==========',
      ' wibble_class:  passed'
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'anything else is amber' do
    assert_equal :amber, colour_of("anything else")
  end

  def colour_of(output)
    OutputParser::parse_funit(output)
  end

end
