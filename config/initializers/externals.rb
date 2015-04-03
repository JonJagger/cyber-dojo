
root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
load "#{root_path}/all.rb"

def cd(name); 'CYBER_DOJO_'+name; end;

ENV[cd('LANGUAGES_ROOT')] = root_path + '/languages/'
ENV[cd('EXERCISES_ROOT')] = root_path + '/exercises/'
ENV[cd('KATAS_ROOT')]     = root_path + '/katas/'

ENV[cd('RUNNER_CLASS_NAME')] = 'DockerTestRunner'
ENV[cd('DISK_CLASS_NAME')] = 'Disk'
ENV[cd('GIT_CLASS_NAME')] = 'Git'
