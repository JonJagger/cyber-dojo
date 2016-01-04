#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerMachineRunnerTests < LibTestBase

  include DockerTestHelpers

  def setup
    super
    set_shell_class    'MockHostShell'
    set_runner_class   'DockerMachineRunner'
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6DAA25',
  'installed? is true when [docker-machine --version] succeeds and cache exists' do
    set_caches_root(tmp_root + 'caches')
    dir = disk[caches.path]
    dir.make
    dir.write(runner.cache_filename, 'present')
    shell.mock_exec(['docker-machine --version'], '', success)
    assert_equal 'DockerMachineRunner', runner.class.name
    assert runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '129439',
  'installed? is false when [docker-machine --version] succeeds but cache does not exist' do
    set_caches_root(tmp_root + 'caches')
    shell.mock_exec(['docker-machine --version'], '', success)
    assert_equal 'DockerMachineRunner', runner.class.name
    refute runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C35391',
  ' installed? is false when [docker-machine --version] does not succeed' do
    shell.mock_exec(['docker-machine --version'], '', not_success)
    assert_equal 'DockerMachineRunner', runner.class.name
    refute runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1E3108',
  'refresh_cache() executes' +
    ' [docker-machine ls] and then' +
    ' [docker-machine ssh sudo docker images] for each node' +
    ' and creates new cache-file in caches/ which determines runnable languages' do

    mock_docker_machine_refresh_cache(['node-00', 'node-01'])
    expected = ['Python, py.test', 'Ruby, Test::Unit']
    actual = runner.runnable_languages.map { |language| language.display_name }.sort
    assert_equal expected, actual
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2D792D',
  'output is left untouched when run() does not time-out' do
    syntax_error = 'syntax-error-line-1'
    mock_run_assert('node-00', syntax_error, syntax_error, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '678D62',
  'output is not truncated and no message is added when run() does not time-out' do
    massive_output = '.' * 75*1024
    mock_run_assert('node-00', massive_output, massive_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '799891',
  'output is replaced by timed-out message when run() times out' do
    output = mock_run('node-00', 'ach-so-it-timed-out', times_out)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def mock_run_assert(node, expected_output, mock_output, mock_exit_status)
    assert_equal expected_output, mock_run(node, mock_output, mock_exit_status)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run(node, mock_output, mock_exit_status)
    mock_docker_machine_refresh_cache([node])
    kata = make_kata(unique_id, 'Python-py.test')
    lion = kata.start_avatar(['lion'])

    args = [
      node,
      lion.sandbox.path,
      lion.kata.language.image_name,
      max_seconds
    ].join(space = ' ')

    shell.mock_cd_exec(
      runner.path,
      ["sudo -u cyber-dojo ./docker_machine_runner.sh #{args}"],
      mock_output,
      mock_exit_status
    )

    runner.run(lion.sandbox, lion.language.image_name, max_seconds)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_docker_machine_refresh_cache(nodes)
    real_caches_root = get_caches_root
    set_caches_root(tmp_root + 'caches/')
    disk[caches.path].make
    # We have reset caches_root so we don't overwrite the true runner's cache
    # But we still need to be able to read the languages and exercises caches.
    `cp #{real_caches_root}/#{Languages.cache_filename} #{caches.path}`
    `cp #{real_caches_root}/#{Exercises.cache_filename} #{caches.path}`

    shell.mock_exec(
      ['sudo -u cyber-dojo docker-machine ls -q'],
      nodes.join("\n"),
      success
    )
    nodes.each do |node|
      shell.mock_exec(
        ["sudo -u cyber-dojo docker-machine ssh #{node} -- sudo docker images"],
        docker_images_python_pytest_and_ruby_testunit,
        success
      )
    end

    refute disk[caches.path].exists?(runner.cache_filename), "!cache exists"
    runner.refresh_cache
    assert disk[caches.path].exists?(runner.cache_filename), "cache exists"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin

  # TODO: restore

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
        deer.sandbox.path,
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
