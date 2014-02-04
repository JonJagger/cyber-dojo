require File.dirname(__FILE__) + '/one_language_checker'

class CppGoogleMockTests < ActionController::TestCase
  
  test "C++GoogleMock" do
    OneLanguageChecker.new.check('C++GoogleMock')        
  end
  
end

