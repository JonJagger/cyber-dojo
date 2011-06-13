
# run all functional tests
# >ruby raf.rb functional/*.rb

ARGV.each {|ft| system("ruby #{ft}") }
