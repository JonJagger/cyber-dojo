require File.dirname(__FILE__) + '/one_language_checker'

class JavaApprovalTests < ActionController::TestCase
  
  test "Java-Approval" do
    OneLanguageChecker.new({ :verbose => true }).check('Java-Approval')        
  end
  
end

