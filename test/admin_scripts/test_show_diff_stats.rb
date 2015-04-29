#!/usr/bin/env ruby

def root_path
  File.expand_path('../..', File.dirname(__FILE__))
end

script_names = %w(
  show_diff_stats.rb
  show_docker_deps.rb
  show_exercises_stats.rb
  show_kata_freq_stats.rb
  show_kata_id_stats.rb
  show_languages_stats.rb
  show_lights_stats.rb
)

$results = { }
script_names.each do |script_name|
  cmd = "#{root_path}/admin_scripts/#{script_name}"
  system(cmd + "> /dev/null")
  $results[script_name] = $?.exitstatus
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# for some reason running the scripts inside a test causes
# them to fail with a weird Array comparison exception

require_relative '../cyberdojo_test_base'

class TestAdminScriptsTests < CyberDojoTestBase

  test 'admin_scripts all have exit_status of zero' do
    $results.each do |script_name,exit_status|
      assert exit_status === 0, script_name
    end
  end

end
