#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputRubyRSpecTests < AppLibTestBase

  test 'one scenario passes, none fail, is green' do
    output = 
    [
      "...",
      "",
      "1 scenario (1 passed)",
      "1 step (1 passed)",
      "0m0.055s"
    ].join("\n")
    assert_equal :green, colour_of(output)    
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'more than one scenario passes, none fail, is green' do
    output = 
    [
      "......",
      "",
      "2 scenarios (2 passed)",
      "6 steps (6 passed)",
      "0m0.055s"
    ].join("\n")
    assert_equal :green, colour_of(output)    
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'one scenario fails, is red' do
    output =
    [
      "..54",
      "F",
      "",
      "....ELIDED...",
      "1 scenario (1 failed)",
      "3 steps (1 failed, 2 passed)",
      "0m0.059s"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'more than one scenario fails, is red' do
    output =
    [
      "..F..F",
      "",
      "(::) failed steps (::)",
      "",
      "",
      "expected: 42",
      "     got: 54",
      "",
      "(compared using ==)",
      "....ELIDED....",
      "2 scenarios (2 failed)",
      "6 steps (2 failed, 4 passed)",
      "0m0.065s"
    ].join("\n")
    assert_equal :red, colour_of(output)        
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'some fails is red' do
    output = 
    [
      ".....F",
      "",
      "(::) failed steps (::)",
      "",
      "",
      "expected: 42",
      "     got: 54",
      "",
      "(compared using ==)",
      " (RSpec::Expectations::ExpectationNotMetError)",
      "./hiker_stepdefs.rb:13:in `/^the score is (\d+)$/'",
      "./hiker.feature:11:in `Then the score is 54'",
      "",
      "Failing Scenarios:",
      "cucumber ./hiker.feature:8 # Scenario: last earthling playing scrabble in the past2",
      "",
      "2 scenarios (1 failed, 1 passed)",
      "6 steps (1 failed, 5 passed)",
      "0m0.062s"
    ].join("\n")
    assert_equal :red, colour_of(output)            
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'some fails with extra debug-style output is red' do
    output = 
    [
      "..42",
      "...54",
      "F",
      "",
      "(::) failed steps (::)",
      "",
      "",
      "expected: 42",
      "     got: 54",
      "",
      "(compared using ==)",
      " (RSpec::Expectations::ExpectationNotMetError)",
      "./hiker_stepdefs.rb:13:in `/^the score is (\d+)$/'",
      "./hiker.feature:11:in `Then the score is 54'",
      "",
      "Failing Scenarios:",
      "cucumber ./hiker.feature:8 # Scenario: last earthling playing scrabble in the past2",
      "",
      "2 scenarios (1 failed, 1 passed)",
      "6 steps (1 failed, 5 passed)",
      "0m0.062s"
    ].join("\n")
    assert_equal :red, colour_of(output)            
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'ruby syntax error is amber' do
    output =
    [
      "/sandbox/hiker.rb:4: syntax error, unexpected $end, expecting keyword_end (SyntaxError)",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/rb_support/rb_language.rb:95:in `load'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/rb_support/rb_language.rb:95:in `load_code_file'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime/support_code.rb:180:in `load_file'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime/support_code.rb:83:in `block in load_files!'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime/support_code.rb:82:in `each'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime/support_code.rb:82:in `load_files!'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime.rb:184:in `load_step_definitions'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/runtime.rb:42:in `run!'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/lib/cucumber/cli/main.rb:47:in `execute!'",
      "/var/lib/gems/1.9.1/gems/cucumber-1.3.14/bin/cucumber:13:in `<top (required)>'",
      "/usr/local/bin/cucumber:23:in `load'",
      "/usr/local/bin/cucumber:23:in `<main>'"      
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def colour_of(output)
    OutputParser::parse_ruby_rspec(output)
  end

end
