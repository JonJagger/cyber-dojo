require File.dirname(__FILE__) + '/one_language_checker'

class RubyRspecTests < ActionController::TestCase
  
  test "Ruby-Rspec" do
    OneLanguageChecker.new({ :verbose => true }).check('Ruby-Rspec')        
  end
  
end

