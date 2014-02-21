require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class ObjectiveCTests < ActionController::TestCase

  test "Objective-C" do
    OneLanguageChecker.new.check('Objective-C')
  end

end
