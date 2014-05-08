require File.dirname(__FILE__) + '/language_manifest_checker'

def show_use(message = "")
  puts
  puts "USE: ruby check_language_manifest.rb [cyber-dojo-root-dir]"
  puts "   checks [cyber-dojo-root-dir]/languages/*/manifest.json"
  puts ""
  puts "USE: ruby check_language_manifest.rb [cyber-dojo-root-dir] [language-dir]"
  puts "   checks [cyber-dojo-root-dir]/languages/[language-dir]/manifest.json"
  puts ""
  puts "   ERROR: #{message}" if message != ""
  puts
end

root_dir = ARGV[0]
language_dir = ARGV[1]

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
puts ""
puts "cyber-dojo-root-dir == #{root_dir}"
puts ""

checker = LanguageManifestChecker.new(root_dir)
if language_dir != nil
  if !File.directory?(root_dir + '/languages/' + language_dir)
    show_use "#{root_dir}/languages does not have a #{language_dir}/ sub-directory"
    exit
  end
  checker.check?(language)
  puts ""
else
  languages = Dir.entries(root_dir + '/languages').select { |name|
    manifest = root_dir + "/languages/#{name}/manifest.json"
    name != '.' and name != '..' and File.file?(manifest)
  }
  languages.sort.each do |language|
    checker.check?(language)
    puts ""
  end
end
