
root_path = File.absolute_path(File.dirname(__FILE__) + '/../../')
load "#{root_path}/all.rb"

def test_runner
  return DockerTestRunner.new if Docker.installed?
  return HostTestRunner.new unless ENV['CYBER_DOJO_USE_HOST'].nil?
  return DummyTestRunner.new
end

include ExternalSetter

set_external(:disk,   Disk.new)
set_external(:git,    Git.new)
set_external(:runner, test_runner)
set_external(:one_self, OneSelf.new)
set_external(:exercises_path, root_path + '/exercises/')
set_external(:languages_path, root_path + '/languages/')
set_external(:katas_path,     root_path + '/katas/')



