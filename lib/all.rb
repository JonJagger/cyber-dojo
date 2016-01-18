
# this list has order dependencies

%w{
  external_parent_chainer
  external_dir

  time_now
  unique_id
  id_splitter
  string_cleaner
  string_truncater
  slashed
  stderr_redirect
  languages_display_names_splitter

  runner
  stub_runner
  docker_runner
  docker_tmp_runner
  docker_katas_runner
  docker_machine_runner
  docker_data_container_runner

  create_kata_manifest
  host_disk_katas

  host_shell
  host_disk
  host_dir
  host_git
  host_log
}.each { |sourcefile| require_relative './' + sourcefile }
