#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'HostTestRunner'

class LanguagesTests < ActionController::TestCase

  def setup
    thread = Thread.current
    thread[:disk]   = OsDisk.new
    thread[:git]    = Git.new
    thread[:runner] = HostTestRunner.new
    @dojo = Dojo.new(root_path)
  end

  test "HostTestRunner says it can run any language" do
    languages = @dojo.languages.entries
    actual = languages.map{|language| language.name}.sort
    expected = [
     "C#-NUnit",
     "C++-GoogleTest",
     "Clojure-.test",
     "Groovy-JUnit",
     "Groovy-Spock",
     "Java-Approval",
     "Objective-C",
     "Ruby-Cucumber",
     "Ruby-Rspec",
     "Ruby-installed-and-working",
     "Ruby-installed-but-not-working",
     "Ruby-not-installed",
     "test-C++-Catch",
     "test-Java-JUnit"
    ]
    assert_equal expected, actual
  end

end
