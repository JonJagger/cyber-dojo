#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts 'USE: check_one_language.rb [<language>] [verbose]'
  puts "   ERROR: #{message}" if message != ''
  puts
end

root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
language = ARGV[0]
verbose = ARGV[1] === 'verbose'

if language.nil?
  show_use('no [language] specified')
  exit
end

if !File.directory?(root_path + '/languages/' + language)
  show_use "#{root_path}/languages/#{language}/ not found"
  exit
end

rag = OneLanguageChecker.new(root_path,verbose).check(language)
expected = ['red','amber','green']
outcome = (rag === expected) ? 'PASS' : 'FAIL'
puts "#{language} --> #{rag} ==> #{outcome}"
