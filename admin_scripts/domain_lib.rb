
# Post-LinuxPaas-refactoring domain lib

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
require 'json'

