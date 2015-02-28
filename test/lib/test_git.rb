#!/usr/bin/env ruby

require_relative 'lib_test_base'

class GitTests < LibTestBase

  include ExternalGit
  include ExternalSetter
  
  def setup
    `rm -rf #{tmp_dir}`
    `mkdir #{tmp_dir}`
    reset_external(:git, Git.new);
    set_path tmp_dir
  end

  def path
    @path
  end
  
  test 'git with no arguments returns externally set :git object' do
    assert_equal 'Git', git.class.name
  end

  test 'git init raises exception if dir does not exist' do
    set_path 'bad_dir'
    error = assert_raises(RuntimeError) { git(:init,'') }
    assert error.message.start_with?("Cannot `cd #{path}")
  end

  test 'git init' do
    message = git(:init,'')
    assert message.end_with?("empty Git repository in #{path}.git/\n")
    uk_git_init_message = message.start_with?('Initialised');
    us_git_init_message = message.start_with?('Initialized');
    assert uk_git_init_message || us_git_init_message
  end

  test 'git add' do
    git(:init, '')
    write_file
    assert_equal "", git(:add, filename)
    status = `cd #{path};git status`
    assert status.include?("new file:   #{filename}")
  end

  test 'git commit' do
    git(:init, '')    
    write_file
    git(:add, filename)
    message = git(:commit, '-am "one"')
    assert message.include?("create mode 100644 #{filename}")
  end

  test 'git rm' do
    git(:init, '')
    write_file
    git(:add, filename)
    git(:commit, '-am "one"')
    message = git(:rm, filename)
    assert message.include?("rm '#{filename}'")
  end

  test 'git tag and show' do
    git(:init, '')
    content = 'greetings'
    write_file(content)
    git(:add, filename)
    git(:commit, '-am "one"')
    tag = git(:tag, "-m '1' 1 HEAD")
    show = git(:show, "1:#{filename}")
    assert_equal content, show
  end

  test 'git diff' do
    git(:init, '')
    old_content = 'aaaaa'
    write_file(old_content)
    git(:add, filename)
    git(:commit, '-am "one"')
    git(:tag, "-m '1' 1 HEAD")
    git(:show, "1:#{filename}")
    new_content = 'bbbbb'
    write_file(new_content)
    git(:add, filename)
    git(:commit, '-am "two"')
    git(:tag, "-m '2' 2 HEAD")
    diff = git(:diff, '1 2')
    assert diff.include?("diff --git a/#{filename} b/#{filename}")
    assert diff.include?("--- a/#{filename}")
    assert diff.include?("+++ b/#{filename}")
    minus,plus = '-','+'
    assert diff.include?(minus + old_content)
    assert diff.include?(plus  + new_content)
  end

  test 'git config' do
    git(:init, '')
    message = git(:config, 'user.name Fred Flintsone')
    assert_equal 0, $?.exitstatus
    assert_equal '', message
  end

  test 'git gc' do
    git(:init, '')
    message = git(:gc, '--auto --quiet')
    assert_equal 0, $?.exitstatus
    assert_equal '', message
  end

  test 'git bad-command logging' do
    git(:init, '')
    message = git(:gc, '--tweedleDee')
    assert_not_equal 0, $?.exitstatus
    assert message.start_with?('error: unknown option')
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
