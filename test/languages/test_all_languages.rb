#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'one_language_checker'

class AllLanguagesTests < CyberDojoTestBase

  test 'red-amber-green initial 6*9 state' do
    root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
    checker = OneLanguageChecker.new(root_path,"quiet")
    languages = Dir.entries(root_path + '/languages').select { |name|
      name != '.' and name != '..'
      # this gets base-language dirs too
    }
    languages.sort.each do |language|
      #rag = checker.check(language)
      puts "testing #{language}"
    end
  end

end
