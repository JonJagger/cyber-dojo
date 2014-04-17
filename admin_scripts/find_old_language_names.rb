
# First post-LinuxPaas-refactoring script to use
# the app/models classes to navigate the domain

require './domain_lib'

disk = OsDisk.new
git = Git.new
runner = DockerRunner.new
paas = LinuxPaas.new(disk, git, runner)
format = 'json'
dojo = paas.create_dojo(CYBERDOJO_HOME_DIR, format)

languages_names = dojo.languages.collect {|language| language.name}

missing = { }
dojo.katas.each do |kata|
  if !languages_names.include? kata.language.name
    missing[kata.language.name] ||= [ ]
    missing[kata.language.name] << kata.id
  end
end

p missing
p missing.keys
