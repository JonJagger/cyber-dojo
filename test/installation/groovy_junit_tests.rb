require File.dirname(__FILE__) + '/one_language_checker'

class GroovyJUnitTests < ActionController::TestCase
  
  test "Groovy-JUnit" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Groovy-JUnit')        
  end
  
end

