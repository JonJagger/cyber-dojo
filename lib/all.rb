
%w{
  External
  ExternalDiskDir
  ExternalGit
  ExternalRunner
  ExternalExercisesPath
  ExternalLanguagesPath
  ExternalKatasPath
  ExternalSetter
  Cleaner
  Docker
  TestRunner
    HostTestRunner
    DockerTestRunner
    DummyTestRunner
  Git
  Disk
  Dir
  TimeNow
  UniqueId
}.each { |sourcefile| require_relative './' + sourcefile }
