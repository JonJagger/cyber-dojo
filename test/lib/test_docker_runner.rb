#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerRunnerTests < LibTestBase

  include DockerTestHelpers

  def setup
    super
    set_katas_root     tmp_root
    set_disk_class     'HostDisk'
    set_git_class      'GitSpy'
    set_one_self_class 'OneSelfDummy'
    @bash = BashStub.new
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  class LanguageMock
    def initialize(image_name)
      @image_name = image_name
    end
    attr_reader :image_name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'refresh_cache executes [docker images]' +
    ' and creates new cache-file in caches which determines runnability' do
    set_disk_class('DiskFake')
    refute disk[caches.path].exists?(DockerRunner.cache_filename)
    @bash.stub(stub_docker_images_python_py_test, success)
    runner = DockerRunner.new(caches, @bash)
    runner.refresh_cache
    assert disk[caches.path].exists?(DockerRunner.cache_filename)
    assert runner.runnable?(LanguageMock.new('cyberdojofoundation/python-3.3.5_pytest'))
    refute runner.runnable?(LanguageMock.new('cyberdojofoundation/not-installed'))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6459A7',
  'run() completes and does not timeout - exact bash cmd interaction' do
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    stub_docker_run(completes)
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal 'blah', output, 'output'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'run() times out - exact base cmd interaction' do
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    stub_docker_run(fatal_error(kill))
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_docker_runner
    DockerRunner.new(caches, @bash, cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bash_commands_spied
    spied = @bash.spied
    n = -1
    assert_equal "rm -f #{cid_filename}", spied[n += 1], 'remove cidfile'
    assert_equal exact_docker_run_cmd,    spied[n += 1], 'main docker run command'
    assert_equal "cat #{cid_filename}",   spied[n += 1], 'get pid from cidfile'
    assert_equal "docker stop #{pid}",    spied[n += 1], 'docker stop pid'
    assert_equal "docker rm #{pid}",      spied[n += 1], 'docker rm pid'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exact_docker_run_cmd
    language = @lion.kata.language
    kata_volume_mount = @lion.sandbox.path + ":/sandbox:rw"

    command = "timeout --signal=#{kill} #{max_seconds}s #{cyber_dojo_cmd} 2>&1"

    "timeout --signal=#{kill} #{max_seconds+5}s" +
      ' docker run' +
        ' --user=www-data' +
        " --cidfile=#{quoted(cid_filename)}" +
        ' --net=none' +
        " -v #{quoted(kata_volume_mount)}" +
        ' -w /sandbox' +
        " #{language.image_name}" +
        " /bin/bash -c #{quoted(command)} 2>&1"
  end

end
