require File.dirname(__FILE__) + '/one_language_checker'

class JavaJUnitTests < ActionController::TestCase
  
  test "Java-JUnit" do
    OneLanguageChecker.new({ :verbose => true }).check('Java-JUnit')        
  end
  
end

