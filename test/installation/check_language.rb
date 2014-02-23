require File.dirname(__FILE__) + '/one_language_checker'

def show_use(message = "")
  puts
  puts "USE: ruby check_language.rb <<cyber-dojo-root-dir>> [<<language>>]"
  puts "   ERROR: #{message}" if message != ""
  puts
end

root_dir = ARGV[0]
language = ARGV[1]

if root_dir == nil
  show_use
  exit
end

if !File.directory?(root_dir)
  show_use "#{root_dir} does not exist"
  exit
end

if root_dir[-1] == '/'
  root_dir = root_dir[0..-2]
end

if !File.directory?(root_dir + '/languages/')
  show_use "#{root_dir} does not have a languages/ sub-directory"
  exit
end

root_dir = File.absolute_path(root_dir)
puts "root-dir == #{root_dir}"

if language != nil
  if !File.directory?(root_dir + '/languages/' + language)
    show_use "#{root_dir}/languages does not have a #{language}/ sub-directory"
    exit
  end
  OneLanguageChecker.new(root_dir,"noisy").check(language)
else
  installed_and_working = [ ]
  not_installed = [ ]
  installed_but_not_working = [ ]
  languages = Dir.entries(root_dir + '/languages').select { |name|
    name != '.' and name != '..'
  }
  # these three are used for mechanism_tests.rb
  languages -= ['Ruby-installed-and-working']
  languages -= ['Ruby-not-installed']
  languages -= ['Ruby-installed-but-not-working']
  languages.sort.each do |language|
    took = OneLanguageChecker.new(root_dir,"quiet").check(
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
