#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputBCPLAllTestsPassedTests < AppLibTestBase

  test 'All tests passed green' do
    output =
      [
        "BCPL 32-bit Cintcode System (30 May 2013)",
        "0.000> ",
        "",
        "BCPL (16 May 2013)",
        "",
        "Code size =   136 bytes of 32-bit little ender Cintcode",
        "",
        "0.010> ",
        "",
        "BCPL 32-bit Cintcode System (30 May 2013)",
        "0.000> All tests passed",
        "",
        "0.000> "
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'bcpl failed returncode is amber' do
    output =
      [
        "bcpl failed returncode 20 reason -1"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'All tests passed as part of diagnostic is amber' do
    output =
      [
        "Error near hiker.test.b[27]:  '}' or '$)' expected",
        "",
        "...se.and.everything()",
        "",
        "  writes(\"All tests passed\")",
        "",
        "}",
        "",
        "bcpl failed returncode 20 reason -1"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'otherwise red' do
    output =
      [
        "BCPL 32-bit Cintcode System (30 May 2013)",
        "0.000> ",
        "",
        "BCPL (16 May 2013)",
        "",
        "Code size =   136 bytes of 32-bit little ender Cintcode",
        "",
        "0.030> ",
        "",
        "BCPL 32-bit Cintcode System (30 May 2013)",
        "0.000> answer() NE 42",
        "",
        "!! ABORT 2: BRK instruction",
        "*"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_bcpl_all_tests_passed(output)
  end

end
