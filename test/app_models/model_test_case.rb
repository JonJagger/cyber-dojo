
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

require 'SpyGit'
require 'DummyGit'

require 'DockerTestRunner'
require 'DummyTestRunner'
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

require 'test/unit'

#=================================================================

class ModelTestCase < Test::Unit::TestCase

  def setup
    create_dojo_format('json')
  end

  def create_dojo_format(format)
    externals = {
      :disk => @disk = SpyDisk.new,
      :git => @git = SpyGit.new,
      :runner => StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,format,externals)
    @max_duration = 15
  end

  def teardown
    @disk.teardown
  end

  def json_and_rb
    yield 'json'
    teardown
    create_dojo_format('rb')
    yield 'rb'
  end

  def filenames_written_to(log)
    # each log entry is of the form
    #  [ 'read'/'write',  filename, content ]
    log.select { |entry| entry[0] == 'write' }.collect{ |entry| entry[1] }
  end

  def make_kata
    visible_files = {
        'wibble.hpp' => '#include <iostream>',
        'wibble.cpp' => '#include "wibble.hpp"'
    }
    language = @dojo.languages['test-C++-Catch']
    language.dir.spy_read('manifest.json', { :visible_filenames => visible_files.keys })
    visible_files.each {|filename,content| language.dir.spy_read(filename, content) }
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.spy_read('instructions', 'your task...')
    @dojo.katas.create_kata(language, exercise)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(@disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = @disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

  def root_path
    ($CYBERDOJO_HOME_DIR + 'test/cyberdojo/').to_s
  end

  def self.test(name, &block)
      define_method("test_#{name}".to_sym, &block)
  end

end
