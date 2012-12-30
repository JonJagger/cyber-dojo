require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/one_language_checker'
require 'Folders'

class InstallationTests < ActionController::TestCase

  test "actual installed languages" do
    puts "Checking the (red,amber,green) installation testing mechanism..."
    ok = check_installed_languages_testing_mechanism
    if !ok
      puts "Installation check failed!!! not testing actual installed languages"
    else
      puts "\nOK. Now determining what's on this Cyber-Dojo server..."
      puts "   (this will take a minute or two)"
      
      installed_and_working,
        cannot_check_because_no_42_file,
          not_installed,
            installed_but_not_working = check_languages(Rails.root)
  
      puts "\nSummary...."    
      puts 'not_installed:' + not_installed.inspect
      puts 'installed-and-working:' + installed_and_working.inspect
      puts 'cannot-check-because-no-42-file:' + cannot_check_because_no_42_file.inspect
      puts 'installed-but-not-working:' + installed_but_not_working.inspect
      
      assert_equal [ ], cannot_check_because_no_42_file
      assert_equal [ ], installed_but_not_working
    end
  end

  def check_installed_languages_testing_mechanism
    installed_and_working,
      cannot_check_because_no_42_file,
        not_installed,
          installed_but_not_working = check_languages(Rails.root + 'test/cyberdojo')
    
    ['C', 'Dummy', 'Ruby-installed-and-working'] == installed_and_working &&
    ['Ruby-no-42-file'] == cannot_check_because_no_42_file &&
    ['C#','Ruby-not-installed'] == not_installed &&
    ['Ruby-installed-but-not-working'] == installed_but_not_working
  end
  
  def check_languages(root_dir)
    @root_dir = root_dir
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
        
    languages_root_dir = root_dir + 'languages'
    languages = Folders::in(languages_root_dir).sort
    
    languages.each do |language|
      OneLanguageChecker.new(verbose=false).check(
        languages_root_dir,
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

