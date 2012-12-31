require File.dirname(__FILE__) + '/one_language_checker'

class ScalaTests < ActionController::TestCase
  
  test "Scala" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new(verbose=true).check(root_dir, 'Scala')        
  end
  
end

