# see comments in app/models/Dojo.rb

root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
load "#{root_path}/all.rb"

def setup_externals
  root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
  load "#{root_path}/lib/all.rb"

  path_vars = [
    'CYBER_DOJO_LANGUAGES_ROOT',
    'CYBER_DOJO_EXERCISES_ROOT',
    'CYBER_DOJO_KATAS_ROOT'
  ]
  class_name_vars = [
    'CYBER_DOJO_DISK_CLASS_NAME',
    'CYBER_DOJO_RUNNER_CLASS_NAME',
    'CYBER_DOJO_GIT_CLASS_NAME'
  ]
  (path_vars + class_name_vars).each do |env_var| 
    raise RuntimeError.new("ENV['#{env_var}'] not set") if ENV[env_var].nil?
  end  
  $cyber_dojo ||= {}
  path_vars.each do |var|
    $cyber_dojo[var] ||= ENV[var]
  end
  class_name_vars.each do |var|
    $cyber_dojo[var] ||= Object.const_get(ENV[var]).new 
  end
end

setup_externals

