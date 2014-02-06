require File.dirname(__FILE__) + '/one_language_checker'

class CppCatchTests < ActionController::TestCase
  
  test "C++-Catch" do
    OneLanguageChecker.new.check('C++-Catch')        
  end
  
end

