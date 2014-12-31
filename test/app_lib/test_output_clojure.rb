#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputClojureTests < AppLibTestBase

  test 'one fail is red' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one error is red' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 1 errors.",
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'no fails and one pass is green' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors."
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one fail on 1st test and no fails on 2nd test is red' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'no fails on 1st test and one fail on 2nd test is red' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'no fails on 1st test and no fail on 2nd test is green' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'mix of amber and red is amber' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
        "Exception in thread"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'mix of amber and green is amber' do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Exception in thread"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'mistake in cyber-dojo.sh is amber' do
    output =
      [
        "./cyber-dojo.sh: 1: xjava: not found"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_clojure_test(output)
  end

end
