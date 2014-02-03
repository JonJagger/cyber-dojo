require File.dirname(__FILE__) + '/one_language_checker'

class CSharpTests < ActionController::TestCase
  
  test "CSharp" do
    OneLanguageChecker.new({ :verbose => true }).check('C#')        
  end
  
end