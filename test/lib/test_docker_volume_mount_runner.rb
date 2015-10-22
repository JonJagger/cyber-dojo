#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerVolumeMountRunnerTests < LibTestBase

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

  test 'EE59BB',
  'initialize() raises RuntimeError when docker is not installed' do
    stub_docker_not_installed
    assert_raises(RuntimeError) { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E58A3B',
  'initialize() uses [docker info]' do
    stub_docker_installed
    make_docker_runner
    assert_equal 'docker info', @bash.spied[0]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3813F9',
  'runnable?() uses [docker images]' do
    stub_docker_installed
    docker = make_docker_runner
    stub_docker_images_python_py_test
    assert docker.runnable?(languages['Python-py.test'])
    refute docker.runnable?(languages['C-assert'])
    assert_equal 'docker images', @bash.spied[1]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6459A7',
  'run() completes and does not timeout - exact bash cmd interaction' do
    stub_docker_installed
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
    stub_docker_installed
    docker = make_docker_runner
    @lion = make_kata.start_avatar(['lion'])
    stub_docker_run(fatal_error(kill))
    output = docker.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_docker_runner
    DockerVolumeMountRunner.new(@bash,cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bash_commands_spied
    spied = @bash.spied
    # 0 docker info from initialize()
    assert_equal "rm -f #{cid_filename}", spied[1], 'remove cidfile'
    assert_equal exact_docker_run_cmd,    spied[2], 'main docker run command'
    assert_equal "cat #{cid_filename}",   spied[3], 'get pid from cidfile'
    assert_equal "docker stop #{pid}",    spied[4], 'docker stop pid'
    assert_equal "docker rm #{pid}",      spied[5], 'docker rm pid'
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
