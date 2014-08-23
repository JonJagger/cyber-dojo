#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts "USE: ruby check_language.rb [language]"
  puts "   ERROR: #{message}" if message != ""
  puts
end

root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
language = ARGV[0]

if language == nil
  show_use("no [language] specified")
  exit
end

if !File.directory?(root_path + '/languages/' + language)
  show_use "#{root_path}/languages/#{language}/ not found"
  exit
end

OneLanguageChecker.new(root_path,"noisy").check(language)
