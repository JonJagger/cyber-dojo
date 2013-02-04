require File.dirname(__FILE__) + '/one_language_checker'

class CSharpTests < ActionController::TestCase
  
  test "CSharp" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'C#')        
  end
  
end