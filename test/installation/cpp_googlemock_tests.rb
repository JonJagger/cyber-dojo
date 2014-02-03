require File.dirname(__FILE__) + '/one_language_checker'

class CppGoogleMockTests < ActionController::TestCase
  
  test "C++GoogleMock" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'C++GoogleMock')        
  end
  
end

