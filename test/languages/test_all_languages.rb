
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
