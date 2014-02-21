require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class ClojureTests < ActionController::TestCase

  test "Clojure" do
    OneLanguageChecker.new.check('Clojure')
  end

end
