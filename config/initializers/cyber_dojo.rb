
def setup_external(key,value)
  root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
  value = root_path + '/' + value + '/' if key.end_with? '_ROOT'
  key = key + '_CLASS_NAME' if !key.end_with? '_ROOT'
  ENV['CYBER_DOJO_' + key] ||= value
  #print "ENV['CYBER_DOJO_#{key}'] ||= '#{value}'\n"
end

setup_external('RUNNER', 'DockerTestRunner')
setup_external(  'DISK', 'Disk')
setup_external(   'GIT', 'Git')

setup_external('LANGUAGES_ROOT', 'languages')
setup_external('EXERCISES_ROOT', 'exercises')
setup_external(    'KATAS_ROOT', 'katas')

