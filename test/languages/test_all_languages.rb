#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'one_language_checker'

class AllLanguagesTests < CyberDojoTestBase

  test 'red-amber-green initial 6*9 state' do
    root_path = File.dirname(__FILE__) + '/../../'
    verbose = false
    checker = OneLanguageChecker.new(root_path,verbose)
    results = {}
    dirs = Dir.glob("#{root_path}languages/*/manifest.json")
    languages = dirs.map{|file| File.dirname(file).split('/')[-1] }
    languages.sort.each do |language|
      rag = checker.check(language)
      results[language] = rag if !rag.nil?
    end
    expected = ['red','amber','green']
    fails  = results.select{|language,rag| rag != expected }
    assert fails == {}, fails.inspect
  end

end

# There is currently a rights issue for this test
# If you run this test as root then it won't work
# because it creates new sub folders under test/cyberdojo/katas
# which are then owned by root and not www-data
# You have to run the tests as www-data
# However, www-data does not have a shell in /etc/passwd
# So you have to temporaily edit etc/passwd so the shell
# for www-data is /bin/bash
# Then
# $ su - www-data
# $ cd /var/www/cyber-dojo/test/languages
# $ ./check_one_language.rb C-assert verbose
# Then exit
# Then edit www-data in etc/passwd back to no shell
# /usr/sbin/nologin
#
# Of course I should create a cyber-dojo user and
# 1) ensure rails create folders/files owned by it
# 2) docker run -u cyber-dojo
# 3) then I could run the tests as this user
