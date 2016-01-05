#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerRunnerTests < LibTestBase

  include DockerTestHelpers

  def setup
    super
    set_shell_class    'MockHostShell'
    set_runner_class   'DockerRunner'
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '329309',
  'installed? is true when [docker --version] succeeds and cache exists' do
    set_caches_root(tmp_root + 'caches')
    dir = disk[caches.path]
    dir.make
    dir.write(runner.cache_filename, 'present')
    shell.mock_exec(['docker --version'], '', success)
    assert_equal 'DockerRunner', runner.class.name
    assert runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2EC2C',
  'installed? is false when [docker --version] succeeds but cache does not exist' do
    set_caches_root(tmp_root + 'caches')
    shell.mock_exec(['docker --version'], '', success)
    assert_equal 'DockerRunner', runner.class.name
    refute runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'FDE315',
  ' installed? is false when [docker --version] does not succeed' do
    shell.mock_exec(['docker --version'], '', not_success)
    assert_equal 'DockerRunner', runner.class.name
    refute runner.installed?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'refresh_cache() executes [docker images]' +
    ' and creates new cache-file in caches/ which determines runnability' do

    real_caches_path = get_caches_root
    set_caches_root(tmp_root + 'caches/')
    disk[caches.path].make

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
  'output is left untouched when run() does not time-out' do
    syntax_error = 'syntax-error-line-1'
    mock_run_assert(syntax_error, syntax_error, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '87A438',
  'massive output is left untouched, (avatar does truncation) when run() does not time-out' do
    massive_output = '.' * 75*1024
    mock_run_assert(massive_output, massive_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B8750C',
  'output is replaced by timed-out message when run() times out' do
    output = mock_run('ach-so-it-timed-out', times_out)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds.")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run_setup(mock_output, mock_exit_status)
    lion = make_kata.start_avatar(['lion'])

    args = [
      lion.sandbox.path,
      lion.kata.language.image_name,
      max_seconds
    ].join(space = ' ')

    shell.mock_cd_exec(
      runner.path,
      ["./docker_runner.sh #{args}"],
      mock_output,
      mock_exit_status
   )
   lion
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run(mock_output, mock_exit_status)
    lion = mock_run_setup(mock_output, mock_exit_status)
    image_name = lion.language.image_name
    delta = { :deleted => [], :new => [], :changed => [] }
    runner.run(lion, delta, files={}, image_name, now=time_now, max_seconds)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def mock_run_assert(expected_output, mock_output, mock_exit_status)
    output = mock_run(mock_output, mock_exit_status)
    assert_equal expected_output, output
  end

  include TimeNow

end
