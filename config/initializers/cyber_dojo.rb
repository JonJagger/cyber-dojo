
$root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
load "#{$root_path}/all.rb"

def setup_external(key,value)
  value = $root_path + '/' + value + '/' if key.end_with? '_ROOT'
  ENV['CYBER_DOJO_' + key] ||= value
end

setup_external('RUNNER_CLASS_NAME', 'DockerTestRunner')
setup_external(  'DISK_CLASS_NAME', 'Disk')
setup_external(   'GIT_CLASS_NAME', 'Git')

setup_external('LANGUAGES_ROOT', 'languages')
setup_external('EXERCISES_ROOT', 'exercises')
setup_external(    'KATAS_ROOT', 'katas')

