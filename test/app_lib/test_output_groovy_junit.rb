#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputGroovyJUnitTests < AppLibTestBase

  test 'groovyc not installed is amber' do
    output = [ "groovyc: command not found" ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'initial red is red' do
    output =
    [
      "JUnit version 4.11",
      ".E",
      "Time: 0.516",
      "There was 1 failure:",
      "1) isItFortyTwo(UntitledTest)",
      "java.lang.AssertionError",
      "	at org.junit.Assert.fail(Assert.java:86)",
      "",
      "	at org.junit.runner.JUnitCore.main(JUnitCore.java:40)",
      "",
      "FAILURES!!!",
      "Tests run: 1,  Failures: 1",
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'initial green is green' do
    output =
    [
      "JUnit version 4.11",
      "",
      "Time: 0.575",
      "",
      "OK (1 test)"
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the first kind is amber' do
    output =
    [
      "org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:",
      "UntitledTest.groovy: 5: unexpected token: @ @ line 5, column 5.",
      "       @Test",
      "       ^",
      "",
      "1 error"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'two passes and no fail is green' do
    output =
    [
      "JUnit version 4.11",
      "..",
      "Time: 0.544",
      "",
      "OK (2 tests)"
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one pass one fail is red' do
    output =
    [
      "JUnit version 4.11",
      "..E",
      "Time: 0.884",
      "There was 1 failure:",
      "1) anotherIsItFortyTwo(UntitledTest)",
      "java.lang.AssertionError",
      "	at org.junit.Assert.fail(Assert.java:86)",
      "",
      "	at org.junit.runner.JUnitCore.main(JUnitCore.java:40)",
      "",
      "FAILURES!!!",
      "Tests run: 2,  Failures: 1"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_junit(output)
  end

end
