require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class JavaApprovalTests < ActionController::TestCase

  test "Java-Approval" do
    OneLanguageChecker.new.check('Java-Approval')
  end

end
