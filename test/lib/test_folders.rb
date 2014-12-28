#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class FoldersTests < CyberDojoTestBase

=begin
  # TODO: these need to be refactored into katas tests
  def setup
    super
    thread[:disk] = OsDisk.new
    thread[:git] = Git.new
    thread[:runner] = HostTestRunner.new
    @dojo = Dojo.new(root_path)
    @path = @dojo.katas.path
    `rm -rf #{@path}`
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete when id is nil is nil' do
    assert_equal nil, Folders::id_complete(@path, nil)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete when id is empty-string is empty string' do
    assert_equal "", Folders::id_complete(@path, "")
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete when id is less than ' +
       '4 chars in length is unchanged id' do
    id = "123"
    assert_equal id, Folders::id_complete(@path, id)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete when id is greater than or equal to ' +
       '10 chars in length is unchanged id' do
    id = "123456789A"
    assert_equal id, Folders::id_complete(@path, id)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete with no matching id is unchanged id' do
    make_dir(@path + '12/345ABCDE/wolf')
    assert_equal '123AEEE', Folders::id_complete(@path, '123AEEE')
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete with one matching id is found and returned as id' do
    make_dir(@path + '12/3579BCDE/wolf')
    assert_equal '123579BCDE', Folders::id_complete(@path, '1235')
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'id_complete with two matching ids found is unchanged id' do
    # 12/345... and 12/346... diff is in 5th character
    make_dir(@path + '12/345ABCDE/wolf')
    make_dir(@path + '12/346ABCDE/wolf')
    assert_equal '1234', Folders::id_complete(@path, '1234')
  end

  def make_dir(path)
    `mkdir -p #{path}`
  end
=end

end
