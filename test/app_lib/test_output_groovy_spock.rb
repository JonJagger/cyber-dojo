#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputGroovySpockTests < AppLibTestBase

  test 'groovyc not installed is amber' do
    output = [ "groovyc: command not found" ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the first kind is amber' do
    output =
    [
      "JUnit version 4.10",
      ".E",
      "Time: 0.37",
      "There was 1 failure:",
      "1) It must be forty two(UntitledSpec)",
      "groovy.lang.MissingPropertyException: No such property: sss for class: UntitledSpec",
      "Possible solutions: class",
      "	at UntitledSpec.It must be forty two(UntitledSpec.groovy:5)",
      "",
      "FAILURES!!!",
      "Tests run: 1,  Failures: 1"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the second kind is amber' do
    output =
    [
      "org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:",
      "UntitledSpec.groovy: 7: unexpected token: ; @ line 7, column 16.",
      "           expect:;",
      "                  ^",
      "",
      "1 error"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one fail is red' do
    output =
    [
      "JUnit version 4.10",
      ".E",
      "Time: 0.74",
      "There was 1 failure:",
      "1) It must be forty two(UntitledSpec)",
      "Condition not satisfied:",
      "",
      "eg.hhg() == (6*9)",
      "|  |     |    |",
      "|  42    |    54",
      "|        false",
      "Untitled@24988707",
      "",
      "	at UntitledSpec.It must be forty two(UntitledSpec.groovy:8)",
      "",
      "FAILURES!!!",
      "Tests run: 1,  Failures: 1"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one pass is red' do
    output =
    [
      "JUnit version 4.10",
      ".",
      "Time: 0.64",
      "",
      "OK (1 test)"
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'no assertions is red' do
    output =
    [
      "JUnit version 4.10",
      "",
      "Time: 0.411",
      "",
      "OK (0 tests)"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_groovy_spock(output)
  end

end
