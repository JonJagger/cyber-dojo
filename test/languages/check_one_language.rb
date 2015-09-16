#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts 'USE: sudo -E -u www-data check_one_language.rb <languageDir> <testDir> [verbose]'
  puts 
  puts '   E.g.  check_one_language.rb C assert verbose'
  puts '         will check cyber-dojo/languages/C/assert/'
  puts
  puts "   ERROR: #{message}" if message != ''
  puts
end

def root_path
  File.absolute_path(File.dirname(__FILE__) + '/../../')
end

language = ARGV[0]
test     = ARGV[1]
verbose  = (ARGV[2] === 'verbose')

if language.nil? or test.nil?
  show_use
  exit
end

if !File.directory?(root_path + '/languages/' + language + '/' + test)
  show_use "#{root_path}/languages/#{language}/#{test}/ not found"
  exit
end

rag = OneLanguageChecker.new(verbose).check(language,test)
expected = ['red','amber','green']
outcome = (rag === expected) ? 'PASS' : 'FAIL'
puts "#{language}/#{test} --> #{rag} ==> #{outcome}"

