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

