#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputPhpUnitTests < AppLibTestBase

  test 'one fail is red' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:54>.",
        "",
        "/var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'one pass is green' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error is amber' do
    output =
      [
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'one pass one fail is red' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        ".F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer2",
        "Failed asserting that <integer:42> matches expected <integer:54>.",
        "",
        "/var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php:15",
        "",
        "FAILURES!",
        "Tests: 2, Assertions: 2, Failures: 1."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'multiple calls in cyber-dojo.sh and ' +
       'one overall-pass and one overall-fail' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:426>.",
        "",
        "/var/www/cyberdojo/sandboxes/67/0194C272/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1.",
        "",
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "SecondTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)",
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'red output then amber output is amber' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:426>.",
        "",
        "/var/www/cyberdojo/sandboxes/67/0194C272/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1.",
        "",
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'green output then amber output is amber' do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "SecondTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)",
        "",
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'phpunit not installed is amber' do
    output = "./cyber-dojo.sh: line 1: phpunit: command not found"
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_php_unit(output)
  end

end
