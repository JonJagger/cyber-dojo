__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/spy_disk'
require __DIR__ + '/spy_git'
require __DIR__ + '/spy_runner'

class ModelTestCase < ActionController::TestCase

  def setup
    create_paas_dojo_format('json')
  end

  def create_paas_dojo_format(format)
    @disk   = SpyDisk.new
    @git    = SpyGit.new
    @runner = SpyRunner.new
    @paas = Paas.new(@disk, @git, @runner)
    @paas.format_rb if format === 'rb'
    @dojo = @paas.create_dojo(root_path)
    @max_duration = 15
  end

  def teardown
    @disk.teardown
  end

  def json_and_rb
    yield 'json'
    teardown
    create_paas_dojo_format('rb')
    yield 'rb'
  end

  def filenames_written_to_in(log)
    # each log entry is of the form
    #  [ 'read'/'write',  filename, content ]
    log.select { |entry| entry[0] == 'write' }.collect{ |entry| entry[1] }
  end

end
