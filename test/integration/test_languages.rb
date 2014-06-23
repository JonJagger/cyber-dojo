#!/usr/bin/env ruby

__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/externals'

class LanguagesTests < ActionController::TestCase

  include Externals

  def setup
    @dojo = Dojo.new(root_path,'json',externals)
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
