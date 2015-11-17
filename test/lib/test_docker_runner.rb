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
    @runner = DockerRunner.new(caches, bash)
  end

  def teardown
    super
  end

  attr_reader :bash, :runner

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'refresh_cache() executes [docker images]' +
    ' and creates new cache-file in caches/ which determines runnability' +
    ' but note that the cache is *not* used by run since only runnable' +
    ' languages are offered at creation. Hmmmm suppose you are rejoining a' +
    ' kata and the dojo has uninstalled the language...' do
    set_disk_class('DiskFake')
    assert_equal [], bash.spied
    refute disk[caches.path].exists?(DockerRunner.cache_filename)
    bash.stub(stub_docker_images_python_pytest, success)
    # when
    runner.refresh_cache
    # then
    assert disk[caches.path].exists?(DockerRunner.cache_filename)
    assert_equal 'docker images', bash.spied[0]
    assert runner.runnable?("#{cdf}/python-3.3.5_pytest")
    refute runner.runnable?("#{cdf}/not-installed")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2E8517',
  'run() passes correct parameters to dedicated shell script' do
    lion = make_kata.start_avatar(['lion'])
    bash.stub('output', success)
    # when
    runner.run(lion.sandbox, max_seconds)
    # then
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
  'output is left untouched when run() does not time-out' do
    lion = make_kata.start_avatar(['lion'])
    bash.stub('syntax-error-line-1', success)
    # when
    output = runner.run(lion.sandbox, max_seconds)
    # then
    assert_equal 'syntax-error-line-1', output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'output is not truncated and no message is added when run() does not time-out' do
    lion = make_kata.start_avatar(['lion'])
    big = '.' * 75*1024
    bash.stub(big, success)
    # when
    output = runner.run(lion.sandbox, max_seconds)
    # then
    assert_equal big, output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'output is replaced by timed-out message when run() times out' do
    lion = make_kata.start_avatar(['lion'])
    bash.stub('ach-so-it-timed-out', times_out)
    # when
    output = runner.run(lion.sandbox, max_seconds)
    # then
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

end
