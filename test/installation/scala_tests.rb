require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'
require 'Folders'

class ScalaTests < ActionController::TestCase
  
  test "scala" do
    root_dir = Rails.root + 'test/cyberdojo'
    languages_root_dir = root_dir + 'languages'
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]        
    
    OneLanguageChecker.new("x").check(
      languages_root_dir,
      'Scala',
      cannot_check_because_no_42_file,
      installed_and_working,
      not_installed,
      installed_but_not_working
    )
  end
end

