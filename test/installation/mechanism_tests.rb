require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'

class MechanismTests < ActionController::TestCase

  test "the (red,amber,green) language mechanism" do
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]

    languages =
      [
        'Ruby-installed-and-working',
        'Ruby-installed-but-not-working',
        'Ruby-not-installed'
      ]

    languages.each do |language|
      took = OneLanguageChecker.new("quiet").check(
        language,
        installed_and_working,
        not_installed,
        installed_but_not_working
      )
    end

    assert_equal ['Ruby-installed-and-working'], installed_and_working
    assert_equal ['Ruby-not-installed'], not_installed
    assert_equal ['Ruby-installed-but-not-working'], installed_but_not_working
  end

end
