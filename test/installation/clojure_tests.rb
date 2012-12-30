require File.dirname(__FILE__) + '/one_language_checker'

class ClojureTests < ActionController::TestCase
  
  test "Clojure" do
    OneLanguageChecker.new(verbose=true).check_one('Clojure')
  end
  
end

