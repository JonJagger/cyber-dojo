
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class ModelTestBase < Test::Unit::TestCase

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  def setup
    thread[:disk] = FakeDisk.new
    thread[:git] = SpyGit.new
    thread[:runner] = StubTestRunner.new
    @dojo = Dojo.new(root_path)
    @max_duration = 15
  end

  include UniqueId

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

  def filenames_written_to(log)
    # each log entry is of the form
    #  [ 'read'/'write',  filename, content ]
    log.select { |entry| entry[0] == 'write' }.collect{ |entry| entry[1] }
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  def disk
    thread[:disk]
  end

  def git
    thread[:git]
  end

  def runner
    thread[:runner]
  end

  def thread
    Thread.current
  end
end
