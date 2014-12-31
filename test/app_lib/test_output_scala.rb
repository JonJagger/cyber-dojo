#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputScalaTestTests < AppLibTestBase

  test "red" do
    output =
      [
        "Total number of tests run: 1",
        "Suites: completed 1, aborted 0",
        "Tests: succeeded 0, failed 1, ignored 0, pending 0"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "amber" do
    output =
      [
        "*** RUN ABORTED ***",
        "  java.lang.ClassNotFoundException: UntitledSuite",
        "  at java.net.URLClassLoader$1.run(URLClassLoader.java:202)"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "green" do
    output =
      [
        "Total number of tests run: 1",
        "Suites: completed 1, aborted 0",
        "Tests: succeeded 1, failed 0, ignored 0, pending 0",
        "All tests passed."
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_scala_test(output)
  end

end
