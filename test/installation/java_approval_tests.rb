require File.dirname(__FILE__) + '/one_language_checker'

class JavaApprovalTests < ActionController::TestCase
  
  test "Java-Approval" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Java-Approval')        
  end
  
end

