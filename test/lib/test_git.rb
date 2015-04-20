#!/usr/bin/env ruby

require_relative 'lib_test_base'

class GitTests < LibTestBase

  include ExternalParentChain
  
  def setup
    super
    `rm -rf #{tmp_dir}`
    `mkdir #{tmp_dir}`
    set_path tmp_dir
    #@parent = self
  end

  def path
    @path
  end
  
  test '[git] with no arguments returns ' +
       'externally set :git object ' +
       'which is used by other tests' do
    object = git
    assert_equal 'Git', object.class.name
  end

  test 'all git commands raise if dir does not exist' do
    set_path 'bad_dir'
    [:init,:config,:add,:rm,:commit,:gc,:tag,:show,:diff].each do |cmd|
      error = assert_raises(Errno::ENOENT) { git(cmd,'') }
      assert error.message.start_with?("No such file or directory")
    end
  end

=begin
  test '[git init] initializes an empty repository in the callers path' do
    message = ok { git(:init,'') }
    uk_git_init_message = message.start_with?('Initialised');
    us_git_init_message = message.start_with?('Initialized');
    assert uk_git_init_message || us_git_init_message
    assert message.end_with?("empty Git repository in #{path}.git/\n")
  end

  test '[git config] succeeds silently' do
    ok { git(:init, '') }
    silent_ok { git(:config, 'user.name Fred Flintsone') }
  end

  test 'git command with bad options returns log of command+message+status' do
    ok { git(:init, '') }
    log = fails { git(:add, 'not-there-file.txt') }
    assert log.include?("git add 'not-there-file.txt")
    assert log.include?('fatal: pathspec')
    assert log.include?("$?.exitstatus=128")
  end
    
  test '[git add] succeeds silently' do
    ok { git(:init, '') }
    write_file
    silent_ok { git(:add, filename) }
  end

  test '[git commit] succeeds non-silently' do
    ok { git(:init, '') }
    write_file
    ok { git(:add, filename) }
    message = ok { git(:commit, '-am "one"') }
    assert message.include?("create mode 100644 #{filename}")
  end

  test '[git rm] succeeds non-silently' do
    ok { git(:init, '') }
    write_file
    ok { git(:add, filename) }
    ok { git(:commit, '-am "one"') }
    message = ok { git(:rm, filename) }
    assert message.start_with?("rm '#{filename}'")
  end

  test '[git show tag:filename] is content of filename for that tag' do
    ok { git(:init, '') }
    content = 'greetings'
    write_file(content)
    ok { git(:add, filename) }
    ok { git(:commit, '-am "one"') }
    ok { git(:tag, "-m '1' 1 HEAD") }
    message = ok { git(:show, "1:#{filename}") }
    assert_equal content, message
  end

  test '[git diff was_tag now_tag] is raw git diff output' do
    ok { git(:init, '') }
    old_content = 'aaaaa'
    write_file(old_content)
    ok { git(:add, filename) }
    ok { git(:commit, '-am "one"') }
    ok { git(:tag, "-m '1' 1 HEAD") }
    ok { git(:show, "1:#{filename}") }
    new_content = 'bbbbb'
    write_file(new_content)
    ok { git(:add, filename) }
    ok { git(:commit, '-am "two"') }
    ok { git(:tag, "-m '2' 2 HEAD") }
    diff = git(:diff, '1 2')
    assert diff.include?("diff --git a/#{filename} b/#{filename}")
    assert diff.include?("--- a/#{filename}")
    assert diff.include?("+++ b/#{filename}")
    assert diff.include?('-' + old_content)
    assert diff.include?('+' + new_content)
  end

  test '[git gc] succeeds silently' do
    ok { git(:init, '') }
    silent_ok { git(:gc, '--auto --quiet') }
  end
=end

  # - - - - - - - - - - - - - - - - - -

  def ok(&block)
    message = block.call
    assert_equal 0, $?.exitstatus
    message
  end

  def silent_ok(&block)
    message = ok(&block)
    assert_equal '', message
  end
  
  def fails(&block)
    message = block.call
    assert_not_equal 0, $?.exitstatus
    message
  end
  
  def set_path(value)
    @path = value
  end
  
  def tmp_dir
    root_path = File.expand_path('../..', File.dirname(__FILE__)) + '/'    
    root_path + 'tmp/'
  end
  
  def filename
    'hello.txt'
  end
    
  def write_file(content = 'anything')
    File.open(path + filename, 'w') do |fd|
      fd.write(content)
    end
  end
  
end
