require File.dirname(__FILE__) + '/one_language_checker'

class ClojureTests < ActionController::TestCase
  
  test "Clojure" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    OneLanguageChecker.new(verbose=true).check(root_dir, 'Clojure')
  end
  
end

