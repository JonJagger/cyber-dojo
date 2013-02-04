require File.dirname(__FILE__) + '/one_language_checker'

class ApprovalTestsJavaTests < ActionController::TestCase
  
  test "ApprovalTests-Java" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'ApprovalTests-Java')        
  end
  
end

