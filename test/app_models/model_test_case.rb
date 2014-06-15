__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require 'SpyDisk'
require 'SpyGit'
require 'StubTestRunner'

class ModelTestCase < ActionController::TestCase

  def setup
    create_dojo_format('json')
  end

  def create_dojo_format(format)
    thread = Thread.current
    @disk   = thread[:disk]   = SpyDisk.new
    @git    = thread[:git]    = SpyGit.new
    @runner = thread[:runner] = StubTestRunner.new
    @dojo = Dojo.new(root_path, format)
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

end
