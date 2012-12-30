require File.dirname(__FILE__) + '/one_language_checker'

class ScalaTests < ActionController::TestCase
  
  test "Scala" do
    OneLanguageChecker.new(verbose=true, max_duration=10).check_one('Scala')
  end
  
end

