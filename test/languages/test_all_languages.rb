#!/usr/bin/env ruby

require_relative 'languages_test_base'
require_relative 'one_language_checker'

class AllLanguagesTests < LanguagesTestBase

  def setup
    `rm -rf #{root_path}test/cyberdojo/katas/*`
  end

  def root_path
    File.absolute_path(File.dirname(__FILE__) + '/../../') + '/'
  end

  test 'red-amber-green initial 6*9 state' do
    return if !Docker.installed?
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
