require File.dirname(__FILE__) + '/one_language_checker'

class InstallationTests < ActionController::TestCase

  test "installed languages" do
    root_dir = Rails.root.to_s + '/test/cyberdojo'
    puts "Checking installed languages (this may take a while)"
    
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
    languages = Folders::in(root_dir + '/languages').sort
    languages -= ['Ruby-installed-and-working']
    languages -= ['Ruby-not-installed']
    languages -= ['Ruby-installed-but-not-working']
    languages.each do |language|
      took = OneLanguageChecker.new("quiet").check(
        language,
        installed_and_working,
        not_installed,
        installed_but_not_working
      )
    end

    puts "\nSummary...."    
    puts 'not_installed:' + not_installed.inspect
    puts 'installed-and-working:' + installed_and_working.inspect
    puts 'installed-but-not-working:' + installed_but_not_working.inspect    
  end
    
end

