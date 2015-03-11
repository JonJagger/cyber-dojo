#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts 'USE: check_one_language.rb [<language>] [<test>] [verbose]'
  puts 
  puts '   E.g.  check_one_language.rb C assert verbose'
  puts '         will check cyber-dojo/languages/C/assert'
  puts
  puts "   ERROR: #{message}" if message != ''
  puts
end

root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
name = ARGV[0]
test = ARGV[1]
verbose = ARGV[2] === 'verbose'

if name.nil? or test.nil?
  show_use
  exit
end

if !File.directory?(root_path + '/languages/' + name + '/' + test)
  show_use "#{root_path}/languages/#{name}/#{test} not found"
  exit
end

rag = OneLanguageChecker.new(root_path,verbose).check(name,test)
expected = ['red','amber','green']
outcome = (rag === expected) ? 'PASS' : 'FAIL'
puts "#{name}/#{test} --> #{rag} ==> #{outcome}"

