# see comments in app/models/Dojo.rb

def check_externals
  root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
  load "#{root_path}/lib/all.rb"

  path_vars = [
    'CYBER_DOJO_LANGUAGES_ROOT',
    'CYBER_DOJO_EXERCISES_ROOT',
    'CYBER_DOJO_KATAS_ROOT'
  ]
  class_name_vars = [
    'CYBER_DOJO_DISK_CLASS',
    'CYBER_DOJO_RUNNER_CLASS',
    'CYBER_DOJO_GIT_CLASS',
    'CYBER_DOJO_ONE_SELF_CLASS'
  ]
  (path_vars + class_name_vars).each do |env_var| 
    raise RuntimeError.new("ENV['#{env_var}'] not set") if ENV[env_var].nil?
  end  
end

check_externals

