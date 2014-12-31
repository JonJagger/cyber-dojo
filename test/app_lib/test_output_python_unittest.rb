#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputPythonUnitTestTests < AppLibTestBase

  test "failing test is red" do
    output =
      [
        "F",
        "======================================================================",
        "FAIL: test_str (__main__.TestUntitled)",
        "simple example to start you off",
        "----------------------------------------------------------------------",
        "Traceback (most recent call last):",
        '  File "test_untitled.py", line 9, in test_str',
        "    self.assertEqual(6 * 9, obj.answer())",
        "AssertionError: 54 != 42",
        "",
        "----------------------------------------------------------------------",
        "Ran 1 test in 0.000s",
        "",
        "FAILED (failures=1)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "one test passed and none failing is green" do
    output =
      [
        ".",
        "----------------------------------------------------------------------",
        "Ran 1 test in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "two tests passed and none failing is green" do
    output =
      [
        "..",
        "----------------------------------------------------------------------",
        "Ran 2 tests in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "one passing test and one failing test is red" do
    output =
      [
        ".F",
        "======================================================================",
        "FAIL: test_str2 (__main__.TestUntitled)",
        "simple example to start you off",
        "----------------------------------------------------------------------",
        "Traceback (most recent call last):",
        '  File "test_untitled.py", line 14, in test_str2',
        "    self.assertEqual(6 * 9, obj.answer())",
        "AssertionError: 54 != 42",
        "",
        "----------------------------------------------------------------------",
        "Ran 2 tests in 0.000s",
        "",
        "FAILED (failures=1)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output =
    [
      "Traceback (most recent call last):",
      '  File "test_untitled.py", line 1, in <module>',
      "    import untitled",
      '  File "/Users/jonjagger/Desktop/Repos/cyberdojo/sandboxes/AB/2ED984F2/hippo/untitled.py", line 4',
      "    return 42sdsdsdsd",
      "                    ^",
      "SyntaxError: invalid syntax"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_python_unittest(output)
  end

end
