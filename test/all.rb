
me = File.dirname(__FILE__)
$CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'

$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/helpers'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/models'

require 'FakeDisk'
require 'SpyDisk'
require 'SpyDir'

require 'SpyGit'
require 'DummyGit'

require 'DockerTestRunner'
require 'DummyTestRunner'
require 'HostTestRunner'
require 'StubTestRunner'

require 'Dojo'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'
require 'Katas'
require 'Kata'
require 'Id'
require 'Avatars'
require 'Avatar'
require 'Sandbox'
require 'Lights'
require 'Light'
require 'Tags'
require 'Tag'
