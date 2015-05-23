
%w{
  Bash
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
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
