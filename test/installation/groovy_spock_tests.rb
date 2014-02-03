require File.dirname(__FILE__) + '/one_language_checker'

class GroovySpockTests < ActionController::TestCase
  
  test "Groovy-Spock" do
    OneLanguageChecker.new({ :verbose => true }).check('Groovy-Spock')        
  end
  
end

