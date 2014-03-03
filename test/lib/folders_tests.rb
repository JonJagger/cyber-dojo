require File.dirname(__FILE__) + '/../test_helper'
require 'Disk'
require 'Folders'

class FoldersTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = Disk.new
    @dojo = Dojo.new(root_path, 'rb')
  end

  test "test languages folder doesn't contain . or .." do
    folders = Folders::in(@dojo.path + '/languages')
    assert_equal 0, folders.count('.')
    assert_equal 0, folders.count('..')
  end

  test "id_complete when id is nil is nil" do
    assert_equal nil, Folders::id_complete(@dojo.path, nil)
  end

  test "id_complete when id is less than 4 chars in length is unchanged id" do
    id = "123"
    assert_equal id, Folders::id_complete(@dojo.path, id)
  end

  test "id_complete when id is greater than or equal to 10 chars in length is unchanged id" do
    id = "123456789A"
    assert_equal id, Folders::id_complete(@dojo.path, id)
  end

  test "id_complete with no matching id is unchanged id" do
    make_dir(@dojo.path + '/katas/12/345ABCDE/wolf')
    assert_equal '123AEEE', Folders::id_complete(@dojo.path, '123AEEE')
  end

  test "id_complete with one matching id is found and returned as id" do
    make_dir(@dojo.path + '/katas/12/3579BCDE/wolf')
    assert_equal '123579BCDE', Folders::id_complete(@dojo.path, '1235')
  end

  test "id_complete with two matching ids found is unchanged id" do
    # 12/345... and 12/346... diff is in 5th character
    make_dir(@dojo.path + '/katas/12/345ABCDE/wolf')
    make_dir(@dojo.path + '/katas/12/346ABCDE/wolf')
    assert_equal '1234', Folders::id_complete(@dojo.path, '1234')
  end

  def make_dir(path)
    `mkdir -p #{path}`
  end
end
