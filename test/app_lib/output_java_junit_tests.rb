# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputJavaJUnitTests < ActionController::TestCase

  include OutputParser

  test "failing test is red" do
    output =
      [
        "JUnit version 4.11-SNAPSHOT-20120416-1530",
        ".E",
        "Time: 0.008",
        "There was 1 failure:",
        "1) hitch_hiker(UntitledTest)",
        "java.lang.AssertionError: expected:<54> but was:<42>",
        "...",
        "",
        "FAILURES!!!",
        "Tests run: 1,  Failures: 1"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output =
      [
        "UntitledTest.java:8: ';' expected",
        "        int expected = 6 * 7s;",
        "                            ^",
        "1 error"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "passing test is green" do
    output =
      [
        "JUnit version 4.11-SNAPSHOT-20120416-1530",
        ".",
        "Time: 0.009",
        "",
        "OK (1 test)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_junit(output)
  end

end
