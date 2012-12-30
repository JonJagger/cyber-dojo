require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'
require 'Folders'

class ObjectiveCTests < ActionController::TestCase
  
  test "objective-c" do
    root_dir = Rails.root + 'test/cyberdojo'
    languages_root_dir = root_dir + 'languages'
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]        
    
    OneLanguageChecker.new(verbose=true).check(
      languages_root_dir,
      'Objective-C',
      cannot_check_because_no_42_file,
      installed_and_working,
      not_installed,
      installed_but_not_working
    )
  end
end
