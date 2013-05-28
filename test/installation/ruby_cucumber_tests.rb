require File.dirname(__FILE__) + '/one_language_checker'

class ScalaTests < ActionController::TestCase
  
  # This fails because there are two files containing 42
  # Not sure what to do about this right now.

  test "Ruby-rspec" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Ruby-Cucumber')        
  end
  
end

