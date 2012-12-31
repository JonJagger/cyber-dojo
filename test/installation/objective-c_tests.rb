require File.dirname(__FILE__) + '/one_language_checker'

class ObjectiveCTests < ActionController::TestCase
  
  test "Objective-C" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new(verbose=true).check(root_dir, 'Objective-C')    
  end

end
