require File.dirname(__FILE__) + '/one_language_checker'

class InstallationTests < ActionController::TestCase

  test "actual installed languages" do
    puts "Checking the (red,amber,green) installation testing mechanism..."
    verify_test_languages
    
    puts "\nOK. Now determining what's on this cyber-dojo server (this will take a while)"    
    installed_and_working,
      not_installed,
        installed_but_not_working = check_installed_languages

    puts "\nSummary...."    
    puts 'not_installed:' + not_installed.inspect
    puts 'installed-and-working:' + installed_and_working.inspect
    puts 'installed-but-not-working:' + installed_but_not_working.inspect    
    #assert_equal [ ], installed_but_not_working
  end

  def verify_test_languages
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
      OneLanguageChecker.new().check(
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
  
  def check_installed_languages
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]        
    languages = Folders::in(root_dir + '/languages').sort    
    languages.each do |language|
      OneLanguageChecker.new().check(
        language,
        installed_and_working,
        not_installed,
        installed_but_not_working
      )
    end
    [
      installed_and_working,
      not_installed,
      installed_but_not_working
    ]    
  end
    
end

