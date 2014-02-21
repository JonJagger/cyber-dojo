require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class CppCatchTests < ActionController::TestCase

  test "C++-Catch" do
    # max_duration 30 is too long
    # cyber-dojo.com is not beefy enough for that
    # so sadly CATCH is not installed
    options = { :verbose => true, :max_duration => 30 }
    OneLanguageChecker.new(options).check('C++-Catch')
  end

end
