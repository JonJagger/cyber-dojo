require File.dirname(__FILE__) + '/one_language_checker'

class ObjectiveCTests < ActionController::TestCase
  
  test "Objective-C" do
    OneLanguageChecker.new(verbose=true).check_one('Objective-C')
  end

end
