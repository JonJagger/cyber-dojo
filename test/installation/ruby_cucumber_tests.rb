require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class RubyCucumberTests < ActionController::TestCase

  # This fails because there are two files containing 42
  # Not sure what to do about this right now.

  test "Ruby-rspec" do
    OneLanguageChecker.new.check('Ruby-Cucumber')
  end

end
