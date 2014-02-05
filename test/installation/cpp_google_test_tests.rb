require File.dirname(__FILE__) + '/one_language_checker'

class CppGoogleTestTests < ActionController::TestCase
  
  test "C++-GoogleTest" do
    options = { :verbose => true, :max_duration => 10 }
    OneLanguageChecker.new(options).check('C++-GoogleTest')        
  end
  
end

