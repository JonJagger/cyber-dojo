#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerMachineRunnerTests < LibTestBase

  def setup
    super
    set_shell_class    'MockHostShell'
    set_runner_class   'DockerMachineRunner'
    set_caches_root tmp_root + 'caches'
    setup_shell_mock_execs_used_to_create_runner_cache
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75919D',
  'first use of runner automatically creates cache by executing' +
    ' [docker-machine ls -q] and then' +
    ' [sudo -u cyber-dojo docker-machine ssh NODE -- sudo docker images] for each node' do
    cache_filename = 'runner_cache.json'
    refute disk[caches.path].exists?(cache_filename)
    runner
    assert disk[caches.path].exists?(cache_filename)

    expected = ['Python, py.test', 'Ruby, Test::Unit']
    actual = runner.runnable_languages.map { |language| language.display_name }.sort
    assert_equal expected, actual
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2D792D',
  'when run() completes and output is less thank 10K ' +
    'then output is left untouched' do
    syntax_error = 'syntax-error-line-1'
    mock_run_assert('node-00', syntax_error, syntax_error, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '678D62',
  'when run() completes and output is larger than 10K ' +
    'then output is truncated to 10K and message is appended ' do
    massive_output = '.' * 75*1024
    expected_output = '.' * 10*1024 + "\n" + 'output truncated by cyber-dojo server'
    mock_run_assert('node-00', expected_output, massive_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '799891',
  'when run() times out ' +
    'then output is replaced by unable-to-complete message ' do
    output = mock_run('node-00', 'ach-so-it-timed-out', times_out)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  private

  include DockerTestHelpers

  def setup_shell_mock_execs_used_to_create_runner_cache
    nodes = ['node-00']
    shell.mock_exec(
      [sudo('docker-machine ls -q')],
      nodes.join("\n"),
      success
    )
    nodes.each do |node|
      shell.mock_exec(
        [sudo("docker-machine ssh #{node} -- sudo docker images")],
        docker_images_python_pytest_and_ruby_testunit,
        success
      )
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run(node, mock_output, mock_exit_status)
    kata = mock_run_setup(node, mock_output, mock_exit_status)
    runner.run(nil, nil, nil, files={}, kata.language.image_name, max_seconds)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run_assert(node, expected_output, mock_output, mock_exit_status)
    assert_equal expected_output, mock_run(node, mock_output, mock_exit_status)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run_setup(node, mock_output, mock_exit_status)
    kata = make_kata({ language:'Python-py.test' })

    args = [
      node,
      runner.tmp_path,
      kata.language.image_name,
      max_seconds
    ].join(space = ' ')

    shell.mock_cd_exec(
      runner.path,
      [sudo("./docker_machine_runner.sh #{args}")],
      mock_output,
      mock_exit_status
    )
    kata
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def sudo(command)
    'sudo -u cyber-dojo ' + command
  end

=begin

  # TODO: restore?

  test 'F73CE7',
  'run() chooses a node at random' do

    kata = make_kata(unique_id, 'Python-py.test')
    deer = kata.start_avatar(['deer'])

    path = tmp_root + 'caches/'
    set_caches_root(path)
    disk[path].make
    mock_docker_machine_refresh_cache
    runner.refresh_cache

    script = lambda do |node|
      args = [
        node,
        path_of(deer.sandbox),
        deer.kata.language.image_name,
        max_seconds
      ].join(space = ' ')

      "cd #{runner.path} && sudo -u cyber-dojo ./docker_machine_runner.sh #{args}"
    end
    # when
    ran_on = { 'node-00' => 0, 'node-01' => 0 }
    25.times do |n|
      bash.reset
      bash.stub('output', success)
      runner.run(deer.sandbox, max_seconds)
      call = bash.spied[0]
      # Hmmmm. Tricky to mock here. Could be either node. Better to spy?
      # Or is this telling me I need to mock the random number generator!?
      # Or should I switch to a round-robin implementation?
      ran_on['node-00'] += 1 if call == script.call('node-00')
      ran_on['node-01'] += 1 if call == script.call('node-01')
    end
    # then
    assert ran_on['node-00'] > 0, ran_on.inspect
    assert ran_on['node-01'] > 0, ran_on.inspect
  end
=end

end


