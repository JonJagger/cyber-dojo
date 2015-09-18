
# this list has order dependencies

%w{
  IdSplitter
  Stderr2Stdout
  Cleaner
  Bash
  BackgroundProcess
  HttpRequester
  Runner
    DockerTimesOutRunner
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
  CurlOneSelf
}.each { |sourcefile| require_relative './' + sourcefile }
