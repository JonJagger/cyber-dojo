#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputGoTests < AppLibTestBase

  test 'build failed is amber' do
    assert_equal :amber, colour_of("[build failed]")
  end

  test 'ran but failed is red' do
    assert_equal :red, colour_of("FAIL")
  end

  test 'ran and passed is green' do
    assert_equal :green, colour_of("PASS")
  end

  test 'anything else is amber' do
    assert_equal :amber, colour_of("anything else")
  end

  test 'check_one_language.rb amber' do
    output =
    [
      "# _/sandbox",
      "./hiker.go:4: syntax error: unexpected name, expecting semicolon or newline or }",
      "FAIL   _/sandbox [build failed]"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  def colour_of(output)
    OutputParser::parse_go_testing(output)
  end

end
