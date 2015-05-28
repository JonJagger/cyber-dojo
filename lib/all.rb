
# this list has order dependencies

%w{
  Stderr2Stdout
  Cleaner  
  Bash
  HttpRequester
  Runner
    DockerRunner
    HostRunner
  Git
  Disk  Dir
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
