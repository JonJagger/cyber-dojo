
# this list has order dependencies

%w{
  id_splitter
  Stderr2Stdout
  string_cleaner
  bash
  background_process
  did_not_complete_in
  docker_machine_runner
  docker_runner
  host_disk
  host_dir
  host_git
  time_now
  unique_id
  languages_display_names_splitter
  one_self_curl
  one_self_dummy
}.each { |sourcefile| require_relative './' + sourcefile }
