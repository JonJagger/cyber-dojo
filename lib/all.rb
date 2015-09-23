
# this list has order dependencies

%w{
  IdSplitter
  Stderr2Stdout
  StringCleaner
  Bash
  BackgroundProcess
  Runner
    DockerTimesOutRunner
    DockerVolumeMountRunner
  HostDisk
  HostDir
  HostGit
  TimeNow
  UniqueId
  LanguagesDisplayNamesSplitter
  OneSelfDummy
  CurlOneSelf
}.each { |sourcefile| require_relative './' + sourcefile }
