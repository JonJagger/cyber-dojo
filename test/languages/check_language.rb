#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts "USE: ruby check_language.rb <<cyber-dojo-root-path>> [<<language>>]"
  puts "   ERROR: #{message}" if message != ""
  puts
end

root_path = ARGV[0]
language = ARGV[1]

if root_path == nil
  show_use
  exit
end

if !File.directory?(root_path)
  show_use "#{root_dir} does not exist"
  exit
end

if root_path[-1] == '/'
  root_path = root_path[0..-2]
end

if !File.directory?(root_path + '/languages/')
  show_use "#{root_dir} does not have a languages/ sub-directory"
  exit
end

root_path = File.absolute_path(root_path)
puts "root-path == #{root_path}"

if language != nil
  if !File.directory?(root_path + '/languages/' + language)
    show_use "#{root_path}/languages does not have a #{language}/ sub-directory"
    exit
  end
  OneLanguageChecker.new(root_path,"noisy").check(language)
else
  installed_and_working = [ ]
  not_installed = [ ]
  installed_but_not_working = [ ]
  languages = Dir.entries(root_path + '/languages').select { |name|
    name != '.' and name != '..'
  }
  # these three are used for mechanism_tests.rb
  languages -= ['Ruby-installed-and-working']
  languages -= ['Ruby-not-installed']
  languages -= ['Ruby-installed-but-not-working']
  checker = OneLanguageChecker.new(root_path,"quiet")
  languages.sort.each do |language|
    took = checker.check(
      language,
      installed_and_working,
      not_installed,
      installed_but_not_working
    )
  end

  puts "\nSummary...."
  puts '            not_installed:' + not_installed.inspect
  puts '    installed-and-working:' + installed_and_working.inspect
  puts 'installed-but-not-working:' + installed_but_not_working.inspect
end
