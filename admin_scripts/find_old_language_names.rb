
me = File.expand_path(File.dirname(__FILE__))
CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'
$LOAD_PATH.unshift CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH.unshift CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH.unshift CYBERDOJO_HOME_DIR + 'app/models'

require 'OsDisk'
require 'OsDir'
require 'Git'
require 'LinuxPaas'
require 'DockerRunner'
require 'Dojo'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'
require 'Katas'
require 'Kata'
require 'Id'
require 'JSON'

#- - - - - - - - - - - - - - - - - - - - - - - - - - -

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
