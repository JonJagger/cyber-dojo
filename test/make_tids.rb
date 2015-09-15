#!/usr/bin/env ruby

# script to help convert test files to use 
# test 'HEX-ID',name BLOCK

def tid
  `uuidgen`.strip.delete('-')[0...6].upcase
end

def id_test
  "  test '#{tid}',"
end

IO.read(ARGV[0]).each_line do |line|
  if m = /^  test '(.*)' \+/.match(line)
    puts id_test
    puts "    '#{m[1].strip}' +"
  elsif m = /^  test '(.*)' do/.match(line)
    puts id_test
    puts "  '#{m[1].strip}' do"
  elsif m = /^  test "(.*)" \+/.match(line)
      puts id_test
      puts "    \"#{m[1].strip}\" +"
  elsif m = /^  test "(.*)" do/.match(line)
      puts id_test
      puts "  \"#{m[1].strip}\" do"
  else
    puts line
  end
end

