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

  attr_reader :bash

  def make_docker_runner
    DockerRunner.new(caches, bash)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'refresh_cache executes [docker images]' +
    ' and creates new cache-file in caches which determines runnability' do
    set_disk_class('DiskFake')
    refute disk[caches.path].exists?(DockerRunner.cache_filename)
    bash.stub(stub_docker_images_python_py_test, success)
    runner = make_docker_runner
    runner.refresh_cache
    assert_equal 'docker images', @bash.spied[0]
    assert disk[caches.path].exists?(DockerRunner.cache_filename)
    assert runner.runnable?('cyberdojofoundation/python-3.3.5_pytest')
    refute runner.runnable?('cyberdojofoundation/not-installed')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2E8517',
  'run() passes correct parameters to dedicated shell script' do
    docker = make_docker_runner
    lion = make_kata.start_avatar(['lion'])
    bash.stub('output', success)
    docker.run(lion.sandbox, max_seconds)
    root_dir = File.expand_path('../..', File.dirname(__FILE__))
    expected =
      "#{root_dir}/lib/docker_runner.sh" +
      " #{lion.sandbox.path}" +
      " #{lion.kata.language.image_name}" +
      " #{max_seconds}"
    call = bash.spied[0]
    assert_equal expected, call
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6459A7',
  'run() gives exact output when it does not timeout' do
    docker = make_docker_runner
    lion = make_kata.start_avatar(['lion'])
    bash.stub('syntax-error-line-1', success)
    output = docker.run(lion.sandbox, max_seconds)
    assert_equal 'syntax-error-line-1', output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'run() output is replaced by timed-out message when it times out' do
    docker = make_docker_runner
    lion = make_kata.start_avatar(['lion'])
    bash.stub('ach-so-it-timed-out', times_out)
    output = docker.run(lion.sandbox, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'run() output is not truncated and no message is added' do
    docker = make_docker_runner
    lion = make_kata.start_avatar(['lion'])
    big = '.' * 75*1024
    bash.stub(big, success)
    output = docker.run(lion.sandbox, max_seconds)
    assert_equal big, output
  end

end
