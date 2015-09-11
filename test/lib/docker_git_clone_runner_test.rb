#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'
require_relative 'DockerTestHelpers'

class DockerGitCloneRunnerTests < LibTestBase

  include DockerTestHelpers

  def setup
    super
    set_disk_class     'DiskStub'
    set_git_class      'GitSpy'
    set_one_self_class 'OneSelfDummy'
    @lion = make_kata.start_avatar(['lion'])
    @bash = BashStub.new
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'initialize() raises RuntimeError when docker is not installed' do
    stub_docker_not_installed
    assert_raises(RuntimeError) { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'initialize() uses [docker info] run as [sudo -u cyber-dojo]' do
    stub_docker_installed
    make_docker_runner
    assert_equal sudoi('docker info'), @bash.spied[0]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'runnable?(language) uses [docker images] run as [sudo -u cyber-dojo]' do
    stub_docker_installed
    docker = make_docker_runner
    stub_docker_images_python_py_test
    assert docker.runnable?(languages['Python-py.test']), 'python_py_test'
    refute docker.runnable?(languages['C-assert']),       'c_assert'
    assert_equal sudoi('docker images'), @bash.spied[1]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'started(avatar) clones avatar repo and pushes it to git server' do
    stub_docker_installed
    docker = make_docker_runner
    assert_equal 1, @bash.spied.size, 'before'
    docker.started(@lion)
    assert_equal 2, @bash.spied.size, 'after'
    bash_cmd = @bash.spied[1]
    assert bash_cmd.include?('git clone --bare lion'), 'creates bare repo'
    assert bash_cmd.include?('sudo -u cyber-dojo scp -r lion.git'), 'copies it to git server'
    assert bash_cmd.include?('git-daemon-export-ok'), 'sets git-daemon-export-ok'
    assert bash_cmd.include?('git remote add master'), 'sets up git remote master 1'
    assert bash_cmd.include?('sudo -u cyber-dojo git push --set-upstream master master'), 'sets up git remote master 1'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'run() completes and does not timeout - exact bash cmd interaction' do
    stub_docker_installed
    make_docker_runner
    stub_docker_run(completes)
    output = @runner.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal 'blah',output, 'output'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'run() times out - exact bash cmd interaction' do
    stub_docker_installed
    make_docker_runner
    stub_docker_run(times_out)
    output = @runner.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_docker_runner
    @runner = DockerGitCloneRunner.new(@bash,cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bash_commands_spied
    spied = @bash.spied
    # 0 docker info from initialize()
    assert_equal exact_git_push_cmd,          spied[1], 'git push'
    assert_equal "rm -f #{cid_filename}",     spied[2], 'remove cidfile'
    assert_equal exact_docker_run_cmd,        spied[3], 'main docker run command'
    assert_equal "cat #{cid_filename}",       spied[4], 'get pid from cidfile'
    assert_equal sudoi("docker stop #{pid}"), spied[5], 'docker stop pid'
    assert_equal sudoi("docker rm #{pid}"),   spied[6], 'docker rm pid'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  include IdSplitter

  def exact_docker_run_cmd
    id = @lion.kata.id

    repo = "git://#{@runner.git_server_ip}/#{outer(id)}/#{inner(id)}/lion.git"

    clone_and_timeout_cmd =
      [
        "git clone #{repo} /tmp/lion 2>&1 > /dev/null",
        "cd /tmp/lion/sandbox && timeout --signal=#{kill} #{max_seconds}s #{cyber_dojo_cmd} 2>&1"
      ].join(';')

    docker_run_cmd =
      "timeout --signal=#{kill} #{max_seconds+5}s" +
        ' docker run' +
          ' --user=www-data' +
          " --cidfile=#{quoted(cid_filename)}" +
          ' --net=host' +
          " #{@lion.kata.language.image_name}" +
          " /bin/bash -c #{quoted(clone_and_timeout_cmd)} 2>&1"

    sudoi(docker_run_cmd)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exact_git_push_cmd
    [
      "cd #{@lion.path}",
      "sudo -u cyber-dojo git commit -am 'pre-test-push' --quiet",
      "sudo -u cyber-dojo git push master"
    ].join(';')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_run(outcome)
    stub_git_push
    stub_rm_cidfile
    stub_timeout(outcome)
    stub_cat_cidfile
    stub_docker_stop
    stub_docker_rm
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def sudoi(s); 'sudo -u cyber-dojo -i' + ' ' + s; end

end
