require File.dirname(__FILE__) + '/one_language_checker'

class GroovySpockTests < ActionController::TestCase
  
  test "Groovy-Spock" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new({ :verbose => true }).check(root_dir, 'Groovy-Spock')        
  end
  
end

