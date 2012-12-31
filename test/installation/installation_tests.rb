require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'
require 'Folders'

class InstallationTests < ActionController::TestCase

  test "actual installed languages" do
    puts "Checking the (red,amber,green) installation testing mechanism..."
    verify_test_languages
    puts "\nOK. Now determining what's on this Cyber-Dojo server (this will take a while)"
    
    installed_and_working,
      cannot_check_because_no_42_file,
        not_installed,
          installed_but_not_working = check_installed_languages

    puts "\nSummary...."    
    puts 'not_installed:' + not_installed.inspect
    puts 'installed-and-working:' + installed_and_working.inspect
    puts 'cannot-check-because-no-42-file:' + cannot_check_because_no_42_file.inspect
    puts 'installed-but-not-working:' + installed_but_not_working.inspect
    
    assert_equal [ ], cannot_check_because_no_42_file
    assert_equal [ ], installed_but_not_working
  end

  def verify_test_languages
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
    
    languages =
      [
        'Ruby-installed-and-working',
        'Ruby-installed-but-not-working',
        'Ruby-no-42-file',
        'Ruby-not-installed'
      ]
    
    languages.each do |language|
      OneLanguageChecker.new(verbose=false).check(
        Rails.root.to_s + '/test/cyberdojo',
        language,
        cannot_check_because_no_42_file,
        installed_and_working,
        not_installed,
        installed_but_not_working
      )
    end
    
    assert_equal ['Ruby-installed-and-working'], installed_and_working           
    assert_equal ['Ruby-no-42-file'], cannot_check_because_no_42_file 
    assert_equal ['Ruby-not-installed'], not_installed                   
    assert_equal ['Ruby-installed-but-not-working'], installed_but_not_working       
  end
  
  def check_installed_languages
    root_dir = Rails.root.to_s
    
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
        
    languages = Folders::in(root_dir + '/languages').sort    
    languages.each do |language|
      OneLanguageChecker.new(verbose=false).check(
        root_dir,
        language,
        cannot_check_because_no_42_file,
        installed_and_working,
        not_installed,
        installed_but_not_working
      )
    end
    [
      installed_and_working,
      cannot_check_because_no_42_file,
      not_installed,
      installed_but_not_working
    ]    
  end
    
end

