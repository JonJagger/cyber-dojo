
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
  redirect

  runner
  docker_runner
  docker_machine_runner
  docker_data_container_runner
  host_disk_katas
  host_shell
  host_disk
  host_dir
  host_git
  host_log
  languages_display_names_splitter
  stub_runner
}.each { |sourcefile| require_relative './' + sourcefile }
