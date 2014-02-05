require File.dirname(__FILE__) + '/one_language_checker'

class CppGoogleTestTests < ActionController::TestCase
  
  test "C++-GoogleTest" do
    OneLanguageChecker.new.check('C++-GoogleTest')        
  end
  
end

