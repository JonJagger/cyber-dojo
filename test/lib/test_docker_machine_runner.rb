#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerMachineRunnerTests < LibTestBase

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

  def runner
    @runner ||= DockerMachineRunner.new(caches, bash)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_machine_refresh_cache
    docker_machine_ls = [ 'node-00', 'node-01' ].join("\n")
    bash.stub(docker_machine_ls, success)
    bash.stub(docker_images_python_pytest, success)                   # node-00
    bash.stub(docker_images_python_pytest_and_ruby_testunit, success) # node-01
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def copy_caches_to_tmp_and_start_deer
    real_caches_root = get_caches_root
    set_caches_root    tmp_root + 'caches'
    `mkdir -p #{get_caches_root}`
    `cp #{real_caches_root}/languages_cache.json #{get_caches_root}`
    `cp #{real_caches_root}/exercises_cache.json #{get_caches_root}`
    assert_equal 'HostDisk', disk.class.name
    assert katas.path.include?('tmp'), 'dont create kata in real katas folder'
    assert caches.path.include?('tmp'), 'dont create caches in real caches folder'
    kata = make_kata(unique_id, 'Python-py.test')
    @deer = kata.start_avatar(['deer'])
    stub_docker_machine_refresh_cache
    runner.refresh_cache
    bash.reset
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1E3108',
  'refresh_cache() executes' +
    ' [docker-machine ls] and then' +
    ' [docker-machine ssh] for each node' +
    ' and creates new cache-file in caches/ which determines runnability' do
    set_disk_class('DiskFake')
    assert_equal [], bash.spied
    stub_docker_machine_refresh_cache
    refute disk[caches.path].exists?(DockerMachineRunner.cache_filename)
    # when
    runner.refresh_cache
    # then
    assert disk[caches.path].exists?(DockerMachineRunner.cache_filename)
    assert_equal 'sudo -u cyber-dojo docker-machine ls -q',                             bash.spied[0]
    assert_equal 'sudo -u cyber-dojo docker-machine ssh node-00 -- sudo docker images', bash.spied[1]
    assert_equal 'sudo -u cyber-dojo docker-machine ssh node-01 -- sudo docker images', bash.spied[2]
    assert runner.runnable?("#{cdf}/python-3.3.5_pytest")
    refute runner.runnable?("#{cdf}/not-installed")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F73CE7',
  'run() passes correct parameters to dedicated shell script' do
    copy_caches_to_tmp_and_start_deer
    #kata = make_kata(unique_id, 'Python-py.test')
    script = lambda do |node|
      "sudo -u cyber-dojo #{root_dir}/lib/docker_machine_runner.sh" +
      " #{node}" +
      " #{@deer.sandbox.path}" +
      " #{@deer.kata.language.image_name}" +
      " #{max_seconds}"
    end
    # when
    counts = { 'node-00' => 0, 'node-01' => 0 }
    25.times do |n|
      bash.reset
      bash.stub('output', success)
      runner.run(@deer.sandbox, max_seconds)
      call = bash.spied[0]
      counts['node-00'] += 1 if call == script.call('node-00')
      counts['node-01'] += 1 if call == script.call('node-01')
    end
    # then
    assert counts['node-00'] > 0, counts.inspect
    assert counts['node-01'] > 0, counts.inspect
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2D792D',
  'output is left untouched when run() does not time-out' do
    copy_caches_to_tmp_and_start_deer
    bash.stub('syntax-error-line-1', success)
    output = runner.run(@deer.sandbox, max_seconds)
    assert_equal 'syntax-error-line-1', output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '678D62',
  'output is not truncated and no message is added when run() does not time-out' do
    copy_caches_to_tmp_and_start_deer
    big = '.' * 75*1024
    bash.stub(big, success)
    output = runner.run(@deer.sandbox, max_seconds)
    assert_equal big, output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '799891',
  'output is replaced by timed-out message when run() times out' do
    copy_caches_to_tmp_and_start_deer
    bash.stub('ach-so-it-timed-out', times_out)
    output = runner.run(@deer.sandbox, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

end
