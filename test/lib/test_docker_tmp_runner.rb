#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerTmpRunnerTests < LibTestBase

  def setup
    super
    set_shell_class 'MockHostShell'
    set_runner_class 'DockerTmpRunner'
    set_caches_root tmp_root + 'caches'
    setup_shell_mock_execs_used_to_create_runner_cache
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8092EF',
  'config/cyber-dojo.json exists and names DockerTmpRunner as the default runner' do
    runner # because of mock_exec
    assert_equal 'DockerTmpRunner', dojo.config['class']['runner']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'first use of runner automatically creates cache by executing [docker images]',
  'which determines runnability' do
    cache_filename = 'runner_cache.json'
    refute disk[caches.path].exists?(cache_filename)
    runner
    assert disk[caches.path].exists?(cache_filename)

    expected = ['Python, py.test']
    actual = runner.runnable_languages.map { |language| language.display_name }.sort
    assert_equal expected, actual
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2E8517',
  'run() passes correct parameters to dedicated shell script' do
    mock_run_assert('output', 'output', success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6459A7',
  'when run() completes and output is less than 10K',
  'then output is left untouched' do
    syntax_error = 'syntax-error-line-1'
    mock_run_assert(syntax_error, syntax_error, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'when run() completes and output is larger than 10K',
  'then output is truncated to 10K and message is appended' do
    massive_output = '.' * 75*1024
    expected_output = '.' * 10*1024 + "\n" + 'output truncated by cyber-dojo server'
    mock_run_assert(expected_output, massive_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'when run() times out',
  'then output is replaced by unable-to-complete message' do
    output = mock_run('ach-so-it-timed-out', times_out)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  private

  include DockerTestHelpers

  def setup_shell_mock_execs_used_to_create_runner_cache
    shell.mock_exec(['docker images'], docker_images_python_pytest, success)
  end

  # - - - - - - - - - - - - - - -

  def mock_run(mock_output, mock_exit_status)
    kata = mock_run_setup(mock_output, mock_exit_status)
    runner.run(nil, nil, nil, files={}, kata.language.image_name, max_seconds)
  end

  # - - - - - - - - - - - - - - -

  def mock_run_assert(expected_output, mock_output, mock_exit_status)
    output = mock_run(mock_output, mock_exit_status)
    assert_equal expected_output, output
  end

  # - - - - - - - - - - - - - - -

  def mock_run_setup(mock_output, mock_exit_status)
    kata = make_kata

    args = [
      runner.tmp_path,
      kata.language.image_name,
      max_seconds
    ].join(space = ' ')

    shell.mock_cd_exec(
      runner.path,
      ["./docker_tmp_runner.sh #{args}"],
      mock_output,
      mock_exit_status
   )

   kata
  end

end
