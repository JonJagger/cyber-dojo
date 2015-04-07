
%w{
  Cleaner
  TestRunner
    HostTestRunner
    DockerTestRunner
    StubTestRunner
  Git
  Disk  Dir
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
