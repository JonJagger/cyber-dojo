
%w{
  External
  ExternalDiskDir
  ExternalGit
  ExternalRunner
  ExternalExercisesPath
  ExternalLanguagesPath
  ExternalKatasPath
  ExternalOneSelf
  Cleaner
  Docker
  TestRunner
    HostTestRunner
    DockerTestRunner
    DummyTestRunner
    StubTestRunner
  Git
  Disk
  Dir
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  OneSelf
}.each { |sourcefile| require_relative './' + sourcefile }
