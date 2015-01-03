#!/usr/bin/env ruby

require_relative 'integration_test_base'

class HostTestRunnerTests < IntegrationTestBase

  test "HostTestRunner says it can run any language" do
    languages = @dojo.languages.each.entries
    languages_names = languages.map{|language| language.name}.sort
    [ "C#-NUnit",
      "C#-SpecFlow",
      "C++-Catch",
      "C++-CppUTest",
      "C++-GoogleTest",
      "C++-assert",
      "C-Unity",
      "C-assert",
      "Clojure-.test",
      "CoffeeScript-jasmine",
      "D-unittest",
      "Erlang-eunit",
      "F#-NUnit",
      "Fortran-FUnit",
      "Go-testing",
      "Groovy-JUnit",
      "Groovy-Spock",
      "Haskell-hunit",
      "Java-1.8_Approval",
      "Java-1.8_Cucumber",
      "Java-1.8_JUnit",
      "Java-1.8_Mockito",
      "Java-1.8_Powermockito",
      "Javascript-assert",
      "Javascript-jasmine",
      "Javascript-mocha_chai_sinon",
      "PHP-PHPUnit",
      "Perl-TestSimple",
      "Python-pytest",
      "Python-unittest",
      "R-RUnit",
      "Ruby-Approval",
      "Ruby-Cucumber",
      "Ruby-Rspec",
      "Ruby-TestUnit",
      "Scala-scalatest"
    ].each do |name|
      assert languages_names.include?(name), name
    end

  end

end
