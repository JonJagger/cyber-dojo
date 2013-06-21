require File.dirname(__FILE__) + '/one_language_checker'

class JavaJUnitTests < ActionController::TestCase
  
  test "Java-JUnit" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Java-JUnit')        
  end
  
end

