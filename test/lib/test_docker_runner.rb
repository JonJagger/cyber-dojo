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
    bash_stub(stub_docker_images_python_py_test, success)
    runner = make_docker_runner
    runner.refresh_cache
    assert disk[caches.path].exists?(DockerRunner.cache_filename)
    assert runner.runnable?(LanguageMock.new('cyberdojofoundation/python-3.3.5_pytest'))
    refute runner.runnable?(LanguageMock.new('cyberdojofoundation/not-installed'))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6459A7',
  'run() does not timeout' do
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    bash_stub('salmon', success)
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal 'salmon', output, 'output'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'run() times out' do
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    bash_stub('timed-out', times_out)
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'run() output is not truncated and no message is added' do
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    big = 'X' * 75*1024
    bash_stub(big, success)
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal big, output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_docker_runner
    DockerRunner.new(caches, @bash)
  end

  def bash_stub(output, exit_status)
    @bash.stub(output, exit_status)
  end

end
