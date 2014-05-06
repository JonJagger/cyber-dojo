require File.dirname(__FILE__) + '/one_language_checker'

class CppGoogleMockTests < ActionController::TestCase

  test "C++-GoogleMock" do
    options = { :verbose => true, :max_duration => 10 }
    OneLanguageChecker.new(options).check('C++-GoogleMock')
  end

end

