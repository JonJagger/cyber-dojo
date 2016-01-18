#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerTmpRunnerTests < LibTestBase

  def setup
    super
    set_shell_class    'MockHostShell'
    set_runner_class   'DockerTmpRunner'
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '329309',
  'installed? is true when docker is installed' do
    shell.mock_exec(['docker --version > /dev/null 2>&1'], '', success)
    assert_equal 'DockerTmpRunner', runner.class.name
    assert runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'FDE315',
  ' installed? is false when docker is not installed' do
    shell.mock_exec(['docker --version > /dev/null 2>&1'], '', not_success)
    assert_equal 'DockerTmpRunner', runner.class.name
    refute runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8092EF',
  'config_filename exists and names DockerTmpRunner as the runner' do
    dir = disk[runner.path]
    assert dir.exists?(runner.config_filename)
    config = dir.read_json(runner.config_filename)
    assert_equal 'DockerTmpRunner', config['class']['runner']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'refresh_cache() executes [docker images]' +
    ' and creates new cache-file in caches/ which determines runnability' do

    real_caches_path = get_caches_root
    set_caches_root(tmp_root + 'caches/')

    cp_command = "cp #{real_caches_path}/#{Languages.cache_filename} #{caches.path}"
    `#{cp_command}`

    shell.mock_exec(['docker images'], docker_images_python_pytest, success)

    refute disk[caches.path].exists?(runner.cache_filename)
    runner.refresh_cache
    assert disk[caches.path].exists?(runner.cache_filename)

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
  'when run() completes and output is not large ' +
    'then output is left untouched' do
    syntax_error = 'syntax-error-line-1'
    mock_run_assert(syntax_error, syntax_error, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'when run() completes and output is large ' +
    'then output is truncated and message is appended ' do
    massive_output = '.' * 75*1024
    expected_output = '.' * 10*1024 + "\n" + 'output truncated by cyber-dojo server'
    mock_run_assert(expected_output, massive_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'when run() times out ' +
    'then output is replaced by unable-to-complete message ' do
    output = mock_run('ach-so-it-timed-out', times_out)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  private

  include DockerTestHelpers

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
      ["./docker_runner.sh #{args}"],
      mock_output,
      mock_exit_status
   )
   kata
  end

end
