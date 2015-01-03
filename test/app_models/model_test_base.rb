
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class ModelTestBase < Test::Unit::TestCase

  def Xroot_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  def setup
    thread[:disk] = DiskFake.new
    thread[:git] = SpyGit.new
    thread[:runner] = StubTestRunner.new
    thread[:exercises_path] = 'exercises/'
    thread[:languages_path] = 'languages/'
    thread[:katas_path]     = 'katas/'
    @dojo = Dojo.new
    @max_duration = 15
  end

  def make_kata(id = unique_id)
    visible_files = {
        'wibble.hpp' => '#include <iostream>',
        'wibble.cpp' => '#include "wibble.hpp"'
    }
    language = @dojo.languages['test-C++-Catch']
    language.dir.write('manifest.json', { :visible_filenames => visible_files.keys })
    visible_files.each { |filename,content| language.dir.write(filename, content) }
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.write('instructions', 'your task...')
    @dojo.katas.create_kata(language, exercise, id)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  include Externals
  include UniqueId

end
