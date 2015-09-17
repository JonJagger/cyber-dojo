#!/bin/bash ../test_wrapper.sh

require_relative 'LanguagesTestBase'
require_relative 'one_language_checker'

class AllLanguagesTests < LanguagesTestBase

  test '1B9010',
  'red-amber-green initial 6*9 state' do
    checker = OneLanguageChecker.new(verbose=true)
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
