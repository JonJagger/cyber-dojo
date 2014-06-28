
require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = [ ]
  end
end

SimpleCov.start do
  add_filter "/ruby-1.9.3-p125/"
  add_filter "/cyberdojo/config/"

  add_group 'app/controllers', 'app/controllers'
  add_group 'app/models'      do |src_file|
      # for some reason SimpleCov is seeing
      # cyberdojo/app/models/Dojo.rb and
      # cyberdojo/app/models/dojo.rb
      # when the later file does not exist!
      src_file.filename.include?('cyberdojo/app/models') &&
      !src_file.filename.include?('dojo.rb')
  end
  add_group 'app/helpers',     'app/helpers'
  add_group 'app/lib',         'app/lib'
  add_group 'integration',     'integration'
  add_group 'lib'             do |src_file|
    src_file.filename.include?('lib') &&
    !src_file.filename.include?('app/lib')
  end

end

SimpleCov.root '/Users/jonjagger/Desktop/Repos/cyberdojo'

#=================================================================

me = File.dirname(__FILE__)
$CYBERDOJO_HOME_DIR = File.expand_path('../..', me) + '/'

$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/helpers'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/models'

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

#- - - - - - - - - - - - - - - - - - - - - - - -

require 'test/unit'

class LibTestBase < Test::Unit::TestCase

  def self.test(name, &block)
      define_method("test_#{name}".to_sym, &block)
  end

end
