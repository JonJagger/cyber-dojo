require File.dirname(__FILE__) + '/one_language_checker'

class ObjectiveCTests < ActionController::TestCase
  
  test "Objective-C" do
    OneLanguageChecker.new({ :verbose => true }).check'Objective-C')    
  end

end
