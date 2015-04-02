
root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
load "#{root_path}/all.rb"

include ExternalRunner
include ExternalDisk
include ExternalGit
include ExternalLanguagesPath
include ExternalExercisesPath
include ExternalKatasPath


set_runner_class_name('HostTestRunner')
set_disk_class_name('Disk')
set_git_class_name('Git')
set_languages_path(root_path + '/languages/')
set_exercises_path(root_path + '/exercises/')
set_katas_path(root_path + '/katas/')
