
# this list has order dependencies

%w{
  external_parent_chainer

  id_splitter
  string_cleaner
  output_or_killed
  docker_machine_runner
  docker_runner
  docker_data_container_runner
  host_shell
  host_disk
  host_disk_avatar_starter
  host_dir
  host_git
  host_log
  time_now
  unique_id
  languages_display_names_splitter
  one_self_curl
  one_self_dummy
  mock_runner
}.each { |sourcefile| require_relative './' + sourcefile }
