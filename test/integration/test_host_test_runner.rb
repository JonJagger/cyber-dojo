#!/usr/bin/env ruby

require_relative 'integration_test_base'

class HostTestRunnerTests < IntegrationTestBase

  test "HostTestRunner says it can run any language" do
    languages = @dojo.languages.each.entries
    languages_names = languages.map{|language| language.display_name}.sort
    
    expected = [ 
      "Asm, assert",
      "BCPL, all_tests_passed",
      "C#, NUnit",
      "C#, SpecFlow",
      "C++, Boost.Test",
      "C++, Catch",
      "C++, CppUTest",
      "C++, GoogleMock",
      "C++, GoogleTest",
      "C++, Igloo",
      "C++, assert",
      "C, CppUTest",
      "C, Unity",
      "C, assert",
      "Clojure, .test",
      "CoffeeScript, jasmine",
      "D, unittest",
      "Erlang, eunit",
      "F#, NUnit",
      "Fortran, FUnit",
      "Go, testing",
      "Groovy, JUnit",
      "Groovy, Spock",
      "Haskell, hunit",
      "Java, Approval",
      "Java, Cucumber",
      "Java, JMock",
      "Java, JUnit",
      "Java, Mockito",
      "Java, PowerMockito",
      "Javascript, assert",
      "Javascript, jasmine",
      "Javascript, Mocha+chai+sinon",
      "PHP, PHPUnit",
      "Perl, Test::Simple",
      "Python, py.test",
      "Python, unittest",
      "R, RUnit",
      "Ruby, Approval",
      "Ruby, Cucumber",
      "Ruby, MiniTest",
      "Ruby, RSpec",
      "Ruby, Test::Unit",
      "Scala, scalatest"
    ]
    
    expected.each do |name|
      assert languages_names.include?(name), name
    end

    left = languages_names - expected
    assert_equal 0, left.size, left
        
  end

end
