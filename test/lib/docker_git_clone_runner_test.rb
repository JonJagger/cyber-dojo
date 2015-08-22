#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class DockerGitCloneRunnerTests < LibTestBase

  def setup
    super
    @bash = BashStub.new
    @cid_filename = 'stub.cid'
    set_disk_class_name     'DiskStub'
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
    @id = '12345ABCDE'
    kata = make_kata(@id)
    @lion = kata.start_avatar(['lion'])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is not installed constructor raises' do
    stub_docker_not_installed
    assert_raises(RuntimeError) { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'bash commands run inside initialize() use sudo' do
    stub_docker_installed
    make_docker_runner
    assert @bash.spied[0].start_with?(sudoi('docker info')), 'docker info'
    assert @bash.spied[1].start_with?(sudoi('docker images')), 'docker images'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is installed, image_names determines runnability' do
    stub_docker_installed
    docker = make_docker_runner
    expected_image_names =
    [
      "cyberdojo/python-3.3.5_pytest",
      "cyberdojo/rust-1.0.0_test"
    ]
    c_assert = languages['C-assert']
    python_py_test = languages['Python-py.test']

    assert_equal expected_image_names, docker.image_names, 'image names'
    refute docker.runnable?(c_assert), 'c_assert'
    assert docker.runnable?(python_py_test), 'python_py_test'
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'started(avatar) clones avatar repo and pushes it to git server' do
    stub_docker_installed
    docker = make_docker_runner
    assert_equal 2, @bash.spied.size, 'before'
    docker.started(@lion)
    assert_equal 3, @bash.spied.size, 'after'    
    bash_cmd = @bash.spied[2]
    assert bash_cmd.include?('git clone --bare lion'), 'creates bare repo'
    assert bash_cmd.include?('sudo -u cyber-dojo scp -r lion.git'), 'copies it to git server'
    assert bash_cmd.include?('git-daemon-export-ok'), 'sets git-daemon-export-ok'
    assert bash_cmd.include?('git remote add master'), 'sets up git remote master 1'
    assert bash_cmd.include?('sudo -u cyber-dojo git push --set-upstream master master'), 'sets up git remote master 1'    
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'pre_test(avatar) commits and pushes to git server' do
    stub_docker_installed
    docker = make_docker_runner
    assert_equal 2, @bash.spied.size, 'before'
    docker.pre_test(@lion)
    assert_equal 3, @bash.spied.size, 'after'
    bash_cmd = @bash.spied[2]
    assert bash_cmd.include?('sudo -u cyber-dojo git commit'), 'git commit'
    assert bash_cmd.include?('sudo -u cyber-dojo git push'), 'git push'
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run does not timeout' do
    stub_docker_installed
    make_docker_runner
    stub_docker_run(completes)
    cmd = 'cyber-dojo.sh'
    output = @runner.run(@lion.sandbox, cmd, max_seconds=5)
    assert_equal 'blah',output, 'output'
    assert_spied(max_seconds, cmd, pid)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run times out' do
    stub_docker_installed
    make_docker_runner
    stub_docker_run(times_out)
    cmd = 'cyber-dojo.sh'
    output = @runner.run(@lion.sandbox, cmd, max_seconds=5)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
    assert_spied(max_seconds, cmd, pid)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  include IdSplitter

  def exact_docker_run_cmd
    repo = "git://#{@runner.git_server_ip}/#{outer(@id)}/#{inner(@id)}/lion.git"
    clone_and_timeout_cmd =
      "git clone #{repo} /tmp/lion 2>&1 > /dev/null;" +
      "cd /tmp/lion/sandbox && timeout --signal=#{kill} 5s cyber-dojo.sh 2>&1"

    "timeout --signal=#{kill} 10s" +
      ' docker run' +
        ' --user=www-data' +
        " --cidfile=#{quoted(@cid_filename)}" +
        ' --net=host' +
        " #{@lion.kata.language.image_name}" +
        " /bin/bash -c #{quoted(clone_and_timeout_cmd)} 2>&1"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def assert_spied(max_seconds, cmd, pid)
    spied = @bash.spied
    assert_equal "rm -f #{@cid_filename}", spied[2], 'remove cidfile'
    assert_equal exact_docker_run_cmd,     spied[3], 'main docker run command'
    assert_equal "cat #{@cid_filename}",   spied[4], 'get pid from cidfile'
    assert_equal "docker stop #{pid}",     spied[5], 'docker stop'
    assert_equal "docker rm #{pid}",       spied[6], 'docker rm'
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def make_docker_runner
    @runner = DockerGitCloneRunner.new(@bash,@cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def sudoi(s); 'sudo -u cyber-dojo -i ' + s; end
  
end
