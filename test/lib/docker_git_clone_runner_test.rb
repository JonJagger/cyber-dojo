#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class DockerGitCloneRunnerTests < LibTestBase

  def setup
    super
    set_disk_class_name     'DiskStub'
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
    @lion = make_kata.start_avatar(['lion'])
    @bash = BashStub.new
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is not installed, initialize() raises RuntimeError' do
    stub_docker_not_installed
    assert_raises(RuntimeError) { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is installed, bash commands run inside initialize() use sudo' do
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

  test 'run() completes and does not timeout' do
    stub_docker_installed
    make_docker_runner
    stub_docker_run(completes)
    output = @runner.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal 'blah',output, 'output'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'run() times out' do
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
    # 0 docker info
    # 1 docker images
    assert_equal exact_git_push_cmd,      spied[2], 'git push'
    assert_equal "rm -f #{cid_filename}", spied[3], 'remove cidfile'
    assert_equal exact_docker_run_cmd,    spied[4], 'main docker run command'
    assert_equal "cat #{cid_filename}",   spied[5], 'get pid from cidfile'
    assert_equal "docker stop #{pid}",    spied[6], 'docker stop pid'
    assert_equal "docker rm #{pid}",      spied[7], 'docker rm pid'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  include IdSplitter

  def exact_docker_run_cmd
    id = @lion.kata.id
    repo = "git://#{@runner.git_server_ip}/#{outer(id)}/#{inner(id)}/lion.git"
    clone_and_timeout_cmd =
      "git clone #{repo} /tmp/lion 2>&1 > /dev/null;" +
      "cd /tmp/lion/sandbox && timeout --signal=#{kill} #{max_seconds}s #{cyber_dojo_cmd} 2>&1"

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
    stub_git_push         # 2
    stub_rm_cidfile       # 3
    stub_timeout(outcome) # 4
    stub_cat_cidfile      # 5
    stub_docker_stop      # 6
    stub_docker_rm        # 7
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def sudoi(s); 'sudo -u cyber-dojo -i' + ' ' + s; end
  
end
