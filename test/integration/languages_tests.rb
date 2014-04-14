require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'RawRunner'

class LanguagesTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = RawRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    format = 'json'
    @dojo = paas.create_dojo(root_path, format)
  end

  test "RawRunner says it can run any language" do
    languages = @dojo.languages.entries
    actual = languages.map{|language| language.name}.sort
    expected = [
     "C#",
     "C++-Catch",
     "C++-GoogleTest",
     "Clojure",
     "Groovy-JUnit",
     "Groovy-Spock",
     "Java-Approval",
     "Java-JUnit",
     "Objective-C",
     "Ruby-Cucumber",
     "Ruby-Rspec",
     "Ruby-installed-and-working",
     "Ruby-installed-but-not-working",
     "Ruby-not-installed",
     "Scala"
    ]
    assert_equal expected, actual
  end

end
