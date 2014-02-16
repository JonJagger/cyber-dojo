require File.dirname(__FILE__) + '/one_language_checker'

class ScalaTests < ActionController::TestCase
  
  test "Scala" do
    options = { :max_duration => 30 }
    OneLanguageChecker.new(options).check('Scala')        
  end
  
end

