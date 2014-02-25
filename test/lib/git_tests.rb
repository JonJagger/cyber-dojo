require File.dirname(__FILE__) + '/../test_helper'
require 'Git'

class GitTests < ActionController::TestCase

  def setup
    @dir = root_path + 'tmp/'
    system("rm -rf #{@dir}")
    system("mkdir #{@dir}")
    @git = Git.new
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "git init" do
    expected = "Initialized empty Git repository in #{@dir}.git/\n"
    assert_equal expected, @git.init(@dir, '')
  end

  test "git add" do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    assert_equal "", @git.add(@dir, 'hello.txt')
    status = `cd #{@dir};git status`
    assert status.include?('new file:   hello.txt')
  end

  test "git commit" do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    @git.add(@dir, 'hello.txt')
    output = @git.commit(@dir, '-am "one"')
    assert output.include?('create mode 100644 hello.txt')
  end

  test "git rm" do
    @git.init(@dir, '')
    File.open(@dir + 'hello.txt', 'w') do |fd|
      fd.write("content")
    end
    @git.add(@dir, 'hello.txt')
    @git.commit(@dir, '-am "one"')
    output = @git.rm(@dir, 'hello.txt')
    assert output.include?("rm 'hello.txt'")
  end

  test "git tag and show" do
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

  test "git diff" do
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

end
