#!/bin/bash ../test_wrapper.sh

require_relative 'languages_test_base'
require_relative 'one_language_checker'

class AllLanguagesTests < LanguagesTestBase

  test 'red-amber-green initial 6*9 state' do
    checker = OneLanguageChecker.new(verbose=false)
    results = {}
    dirs = Dir.glob("#{languages.path}*/*/manifest.json")
    languages = dirs.map { |file|
      File.dirname(file).split('/')[-2..-1]
    }
    languages.sort.each do |array|
      rag = checker.check(*array)
      results[array] = rag if !rag.nil?
    end
    expected = ['red','amber','green']
    fails  = results.select{|language,rag| rag != expected }
    assert fails == {}, fails.inspect
  end

end
