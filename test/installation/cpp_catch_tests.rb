require File.dirname(__FILE__) + '/one_language_checker'

class CppCatchTests < ActionController::TestCase
  
  test "C++-Catch" do
    options = { :verbose => true, :max_duration => 30 }
    OneLanguageChecker.new(options).check('C++-Catch')        
  end
  
end

