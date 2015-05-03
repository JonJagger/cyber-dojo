
%w{
  Cleaner
  TestRunner
    DockerTestRunner
    HostTestRunner
  Git
  Disk  Dir
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  ChildProcess
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
