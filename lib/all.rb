
# this list has order dependencies

%w{
  id_splitter
  Stderr2Stdout
  string_cleaner
  bash
  background_process
  runner
    docker_times_out_runner
    docker_runner
  host_disk
  host_dir
  host_git
  time_now
  unique_id
  languages_display_names_splitter
  one_self_dummy
  curl_one_self
}.each { |sourcefile| require_relative './' + sourcefile }
