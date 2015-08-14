
# this list has order dependencies

%w{
  IdSplitter
  Stderr2Stdout
  Cleaner  
  Bash
  HttpRequester
  Runner
    DockerGitCloneRunner
    DockerVolumeMountRunner
    HostRunner
  HostDisk  
  HostDir
  HostGit
  TimeNow
  UniqueId
  LanguagesDisplayNamesSplitter
  OneSelf  
  OneSelfDummy
}.each { |sourcefile| require_relative './' + sourcefile }
