
%w{
  Cleaner
  TestRunner
    HostTestRunner
    DockerTestRunner
    DummyTestRunner
    StubTestRunner
  Git
  Disk  Dir
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
