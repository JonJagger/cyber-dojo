
# this list has order dependencies

%w{
  external_parent_chainer

  time_now
  unique_id
  id_splitter
  string_cleaner
  string_truncater
  stderr_redirect
  unslashed
  languages_display_names_splitter

  runner
  stub_runner
  docker_runner
  docker_tar_pipe_runner
  docker_machine_runner

  create_kata_manifest
  host_disk_katas

  host_shell
  host_disk
  host_dir
  host_git
  memory_log
  stdout_log
}.each { |sourcefile| require_relative './' + sourcefile }
