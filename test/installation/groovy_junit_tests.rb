require File.dirname(__FILE__) + '/one_language_checker'

class GroovyJUnitTests < ActionController::TestCase
  
  test "Groovy-JUnit" do
    OneLanguageChecker.new({ :verbose => true }).check('Groovy-JUnit')        
  end
  
end

