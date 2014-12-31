#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputJavaCucumberTests < AppLibTestBase

  test 'initial test is red' do
    output =
      [
        "JUnit version 4.11",
        "....EE",
        "1 Scenarios (1 failed)",
        "3 Steps (1 failed, 2 passed)",
        "0m0.162s",
        "",
        "java.lang.AssertionError: expected:<42> but was:<54>",
        "	at org.junit.Assert.fail(Assert.java:88)",
        "	at org.junit.Assert.failNotEquals(Assert.java:743)",
        "	at org.junit.Assert.assertEquals(Assert.java:118)",
        "	at org.junit.Assert.assertEquals(Assert.java:555)",
        "	at org.junit.Assert.assertEquals(Assert.java:542)",
        "	at HikerStepDef.theScoreIs(HikerStepDef.java:20)",
        "	at ?.Then the score is 42(Hiker.feature:7)",
        "",
        "",
        "Time: 0.313",
        "There were 2 failures:",
        "1) Then the score is 42(Scenario: last earthling playing scrabble in the past)",
        "java.lang.AssertionError: expected:<42> but was:<54>",
        "	at org.junit.Assert.fail(Assert.java:88)",
        "	at org.junit.Assert.failNotEquals(Assert.java:743)",
        "	at org.junit.Assert.assertEquals(Assert.java:118)",
        "	at org.junit.Assert.assertEquals(Assert.java:555)",
        "	at org.junit.Assert.assertEquals(Assert.java:542)",
        "	at HikerStepDef.theScoreIs(HikerStepDef.java:20)",
        "	at ?.Then the score is 42(Hiker.feature:7)",
        "2) Scenario: last earthling playing scrabble in the past",
        "java.lang.AssertionError: expected:<42> but was:<54>",
        "	at org.junit.Assert.fail(Assert.java:88)",
        "	at org.junit.Assert.failNotEquals(Assert.java:743)",
        "	at org.junit.Assert.assertEquals(Assert.java:118)",
        "	at org.junit.Assert.assertEquals(Assert.java:555)",
        "	at org.junit.Assert.assertEquals(Assert.java:542)",
        "	at HikerStepDef.theScoreIs(HikerStepDef.java:20)",
        "	at ?.Then the score is 42(Hiker.feature:7)",
        "",
        "FAILURES!!!",
        "Tests run: 4,  Failures: 2"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test 'missing steps is red' do
    output =
      [
        "JUnit version 4.11",
        "..EEI",
        "1 Scenarios (1 undefined)",
        "3 Steps (1 skipped, 1 undefined, 1 passed)",
        "0m0.177s",
        "",
        "",
        "You can implement missing steps with the snippets below:",
        "",
        "@When(\"^they spell (\\d+) times (\\d+)typo$\")",
        "public void theySpellTimesTypo(int arg1, int arg2) throws Throwable {",
        "    // Write code here that turns the phrase above into concrete actions",
        "    throw new PendingException();",
        "}",
        "",
        "",
        "Time: 0.345",
        "There were 2 failures:",
        "1) When they spell 6 times 9typo(Scenario: last earthling playing scrabble in the past)",
        "cucumber.api.PendingException: TODO: implement me",
        "	at cucumber.runtime.junit.JUnitReporter.addFailure(JUnitReporter.java:120)",
        "	at cucumber.runtime.junit.JUnitReporter.addFailureOrIgnoreStep(JUnitReporter.java:109)",
        "	at cucumber.runtime.junit.JUnitReporter.result(JUnitReporter.java:79)",
        "	LOTS ELIDED",
        "2) Scenario: last earthling playing scrabble in the past",
        "cucumber.api.PendingException: TODO: implement me",
        "	at cucumber.runtime.junit.JUnitReporter.addFailure(JUnitReporter.java:120)",
        "	at cucumber.runtime.junit.JUnitReporter.addFailureOrIgnoreStep(JUnitReporter.java:109)",
        "	at cucumber.runtime.junit.JUnitReporter.result(JUnitReporter.java:79)",
        "	LOTS ELIDED",
        "",
        "FAILURES!!!",
        "Tests run: 2,  Failures: 2"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test 'syntax error is amber' do
    output =
      [
        "Hiker.java:6: <identifier> expected",
        "    }ssss",
        "         ^",
        "Hiker.java:7: reached end of file while parsing",
        "}",
        " ^",
        "2 errors"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  test 'passing test is green' do
    output =
      [
        "JUnit version 4.11",
        "....",
        "1 Scenarios (1 passed)",
        "3 Steps (3 passed)",
        "0m0.166s",
        "",
        "",
        "Time: 0.296",
        "",
        "OK (4 tests)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  def colour_of(output)
    OutputParser::parse_java_cucumber(output)
  end

end
