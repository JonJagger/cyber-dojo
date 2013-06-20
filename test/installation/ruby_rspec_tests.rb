require File.dirname(__FILE__) + '/one_language_checker'

class RubyRspecTests < ActionController::TestCase
  
  test "Ruby-Rspec" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Ruby-Rspec')        
  end
  
end

