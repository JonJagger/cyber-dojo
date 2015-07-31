
# this list has order dependencies

%w{
  Stderr2Stdout
  Cleaner  
  Bash
  HttpRequester
  Runner
    DockerVolumeMountRunner
    HostRunner
  HostDisk  
  HostDir
  HostGit
  TimeNow
  UniqueId
  IdSplitter
  LanguagesDisplayNamesSplitter
  OneSelf  
}.each { |sourcefile| require_relative './' + sourcefile }
