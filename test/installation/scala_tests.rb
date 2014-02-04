require File.dirname(__FILE__) + '/one_language_checker'

class ScalaTests < ActionController::TestCase
  
  test "Scala" do
    OneLanguageChecker.new.check('Scala')        
  end
  
end

