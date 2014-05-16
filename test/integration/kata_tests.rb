require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'DummyRunner'

class KataTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = DummyRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    @dojo = paas.create_dojo(root_path)
  end

  test "exists? is false for empty-string id" do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end

# Tracked down a fault which resulted in
# .../katas/hippo/.git
# being created rather than .../katas/34/76ED5521/hippo/.git (say)
#
# dojo_controller.rb enter_json() does this...
#     kata = dojo.katas[id]
#     exists = kata.exists?
#     avatar = (exists ? kata.start_avatar : nil)
#
# and kata.exists?() did this...
#    paas.exists?(self)
#
# which resulted in this...
#    dir(kata).exists?
#
# and dir(object) did this...
#    disk[path(obj)]
#
# and path(obj) did this...
#   when Kata
#      path(obj.dojo.katas) + obj.id.inner + '/' + obj.id.outer + '/'
#
# now, if obj.id is the empty string this will result in
#    disk['.../katas///'].exists?
#
# and OsDir.exists?() did this...
#    File.directory?('.../katas///')
#
# which was true. The slashes collapse.
# So kata.start_avatar was called
# which made the 'hippo' sub folder
# and the git_init() made the git repo.
