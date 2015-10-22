
%w{
  bash_stub
  disk_stub
  disk_fake
  dir_fake
  git_spy
  runner_stub
  runner_stub_true
}.each {|sourcefile| require_relative './' + sourcefile }
