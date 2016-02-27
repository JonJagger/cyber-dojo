#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative './docker_test_helpers'

class DockerKatasDataContainerRunnerTest < LibTestBase

  def setup
    super
    set_shell_class 'MockHostShell'
    set_runner_class 'DockerKatasDataContainerRunner'
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75909D',
  'mock_execs used to create runner cache' do
    p "TODO: ADD SUDO"
    shell.mock_exec(['docker images'], docker_images_python_pytest, success)
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
    max_seconds = dojo.env('runner', 'timeout')
    expected = "Unable to complete the tests in #{max_seconds} seconds."
    assert output.start_with?(expected), output
  end

  private

  include DockerTestHelpers

  # - - - - - - - - - - - - - - -

  def mock_run_assert(expected_output, mock_output, mock_exit_status)
    output = mock_run(mock_output, mock_exit_status)
    assert_equal expected_output, output
  end

  # - - - - - - - - - - - - - - -

  def mock_run(mock_output, mock_exit_status)
    lion = mock_run_setup(mock_output, mock_exit_status)
    delta = { deleted: {}, new: {}, changed: {} }
    runner.run(lion, delta, files={}, lion.kata.language.image_name)
  end

  # - - - - - - - - - - - - - - -

  def mock_run_setup(mock_output, mock_exit_status)
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    args = [
      katas.path_of(lion.sandbox),
      kata.language.image_name,
      dojo.env('runner', 'timeout'),
      quoted(dojo.env('runner','sudo'))
    ].join(space = ' ')

    shell.mock_cd_exec(
      runner.path,
      ["./docker_katas_data_container_runner.sh #{args}"],
      mock_output,
      mock_exit_status
   )
   lion
  end

  # - - - - - - - - - - - - - - -

  def quoted(s)
    "'" + s + "'"
  end

end
