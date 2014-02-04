require File.dirname(__FILE__) + '/one_language_checker'

class JavaJUnitTests < ActionController::TestCase
  
  test "Java-JUnit" do
    OneLanguageChecker.new.check('Java-JUnit')        
  end
  
end

