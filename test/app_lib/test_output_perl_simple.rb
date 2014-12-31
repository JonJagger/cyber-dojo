#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputPerlTests < AppLibTestBase

  test "one failing test is red" do
    output =
      [
        "#   Failed test 'Life, the universe, and everything'",
        "#   at untitled.t line 7.",
        "# Looks like you failed 1 test of 1.",
        "untitled.t .. ",
        "Dubious, test returned 1 (wstat 256, 0x100)",
        "Failed 1/1 subtests ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 256 Tests: 1 Failed: 1)",
        "  Failed test:  1",
        "  Non-zero exit status: 1",
        "Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.02 cusr  0.01 csys =  0.06 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 1/1 subtests failed."
     ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "one passing test is green" do
    output =
      [
        "untitled.t .. ok",
        "All tests successful.",
        "Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: PASS"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "one passing test and one failing test is red" do
    output =
      [
        "#   Failed test 'Life, the universe, and everything'",
        "#   at untitled.t line 9.",
        "# Looks like you failed 1 test of 2.",
        "untitled.t .. ",
        "Dubious, test returned 1 (wstat 256, 0x100)",
        "Failed 1/2 subtests ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 256 Tests: 2 Failed: 1)",
        "  Failed test:  2",
        "  Non-zero exit status: 1",
        "Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 1/2 subtests failed."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output =
      [
        'Bareword found where operator expected at untitled.t line 7, near "7sss"',
        "	(Missing operator before sss?)",
        'syntax error at untitled.t line 7, near "7sss"',
        "Execution of untitled.t aborted due to compilation errors.",
        "# Looks like your test exited with 255 before it could output anything.",
        "untitled.t .. ",
        "Dubious, test returned 255 (wstat 65280, 0xff00)",
        "No subtests run ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 65280 Tests: 0 Failed: 0)",
        "  Non-zero exit status: 255",
        "  Parse errors: No plan found in TAP output",
        "Files=1, Tests=0,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.06 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 0/0 subtests failed.",
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "aborted due to compilation errors is amber" do
    output =
      [
        'Bareword "sss" not allowed while "strict subs" in use at untitled.t line 8.',
        "Execution of untitled.t aborted due to compilation errors.",
        "# Looks like your test exited with 255 before it could output anything.",
        "untitled.t .. ",
        "Dubious, test returned 255 (wstat 65280, 0xff00)",
        "No subtests run ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 65280 Tests: 0 Failed: 0)",
        "  Non-zero exit status: 255",
        "  Parse errors: No plan found in TAP output",
        "Files=1, Tests=0,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 0/0 subtests failed."
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_perl_test_simple(output)
  end

end
