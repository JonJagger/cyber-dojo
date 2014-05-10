require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'HostRunner'

class LanguagesTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = HostRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    format = 'json'
    @dojo = paas.create_dojo(root_path, format)
  end

  test "HostRunner says it can run any language" do
    languages = @dojo.languages.entries
    actual = languages.map{|language| language.name}.sort
    expected = [
     "C#-NUnit",
     "C++-Catch",
     "C++-GoogleTest",
     "Clojure-.test",
     "Groovy-JUnit",
     "Groovy-Spock",
     "Java-Approval",
     "Java-JUnit",
     "Objective-C",
     "Ruby-Cucumber",
     "Ruby-Rspec",
     "Ruby-installed-and-working",
     "Ruby-installed-but-not-working",
     "Ruby-not-installed"
    ]
    assert_equal expected, actual
  end

end
