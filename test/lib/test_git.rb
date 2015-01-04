#!/usr/bin/env ruby

require_relative 'lib_test_base'

class GitTests < LibTestBase

  def setup
    @dir = root_path + 'tmp/'
    `rm -rf #{@dir}`
    `mkdir #{@dir}`
    @git = Git.new
  end

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git init raises exception if dir does not exist' do
    bad_dir = 'notThere'
    error = assert_raises(RuntimeError) { @git.init(bad_dir,'') }
    assert error.message.start_with?("Cannot `cd #{bad_dir}")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git init' do
    expected = "Initialized empty Git repository in #{@dir}.git/\n"
    assert_equal expected, @git.init(@dir, '')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git add' do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    assert_equal "", @git.add(@dir, 'hello.txt')
    status = `cd #{@dir};git status`
    assert status.include?('new file:   hello.txt')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git commit' do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    @git.add(@dir, 'hello.txt')
    output = @git.commit(@dir, '-am "one"')
    assert output.include?('create mode 100644 hello.txt')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git rm' do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    @git.add(@dir, 'hello.txt')
    @git.commit(@dir, '-am "one"')
    output = @git.rm(@dir, 'hello.txt')
    assert output.include?("rm 'hello.txt'")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git tag and show' do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    @git.add(@dir, 'hello.txt')
    @git.commit(@dir, '-am "one"')
    tag = @git.tag(@dir, "-m '1' 1 HEAD")
    show = @git.show(@dir, "1:hello.txt")
    assert_equal "content", show
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git diff' do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("aaaaa")
    end
    @git.add(@dir, 'hello.txt')
    @git.commit(@dir, '-am "one"')
    @git.tag(@dir, "-m '1' 1 HEAD")
    @git.show(@dir, "1:hello.txt")
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("bbbbb")
    end
    @git.add(@dir, 'hello.txt')
    @git.commit(@dir, '-am "two"')
    @git.tag(@dir, "-m '2' 2 HEAD")
    diff = @git.diff(@dir, '1 2')
    assert diff.include?("diff --git a/hello.txt b/hello.txt")
    assert diff.include?("--- a/hello.txt")
    assert diff.include?("+++ b/hello.txt")
    assert diff.include?("-aaaaa")
    assert diff.include?("+bbbbb")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git config' do
    cfg = @git.config(@dir, 'user.name Fred Flintsone')
    assert_equal 0, $?.exitstatus
    assert_equal '', cfg
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git gc' do
    gc = @git.gc(@dir, '--auto --quiet')
    assert_equal 0, $?.exitstatus
    assert_equal '', gc
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'git bad-command logging' do
    gc = @git.gc(@dir, '--automatic')
    assert_not_equal 0, $?.exitstatus
    assert gc.start_with?('error: unknown option')
  end

end
