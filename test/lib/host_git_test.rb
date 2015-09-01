#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class HostGitTests < LibTestBase

  include ExternalParentChain
  
  class StubDojo
    def git(*args)
      @git ||= HostGit.new
    end
  end
  
  def setup
    super
    mkdir = "mkdir -p #{tmp_dir}"
    rmgit = "rm -rf #{tmp_dir}/.git"
    `#{mkdir} && #{rmgit}`
    # force ExternalParentChain.method_missing
    # (LibTestBase has git helper method)
    undef :git if respond_to? :git
    # ExternalParentChain requires @parent
    set_path tmp_dir    
    @parent = StubDojo.new
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
  test '[git] with no arguments returns ' +
       'externally the set :git object ' +
       'which can be Stub object' do
    assert_equal 'HostGit', git.class.name
  end

  test 'all git commands raise exception if path names a dir that does not exist' do
    set_path 'dir_that_does_not_exist'
    [:init,:config,:add,:rm,:commit,:gc,:tag,:show,:diff].each do |cmd|
      error = assert_raises(Errno::ENOENT) { 
        args = ''
        git.send(cmd, path, args)
      }
      assert error.message.start_with?("No such file or directory")
    end
  end

  test '[git init] initializes an empty repository in the callers path' do
    message = ok { git.init(path, '') }
    uk_git_init_message = message.start_with?('Initialised');
    us_git_init_message = message.start_with?('Initialized');
    assert uk_git_init_message || us_git_init_message
    assert message.end_with?("empty Git repository in #{path}.git/\n")
  end
  
  test '[git config] succeeds silently' do
    ok { git.init(path, '') }
    silent_ok { git.config(path, 'user.name "Fred Flintsone"') }
    # sometimes the above git.config command somehow has the 
    # following effect on .git/config on the main cyber-dojo repo?!
    #
    # [user]
	  #         name = Jon Jagger
    #         name = Fred
    #
    fred = `grep Fred /var/www/cyber-dojo/.git/config`
    assert fred==='', "Fred is back in /var/www/cyber-dojo/.git/config"
  end

  test 'git command with bad options returns log of command+message+status' do
    ok { git.init(path, '') }
    log = fails { git.add(path, 'not-there-file.txt') }
    assert log.include?("git add 'not-there-file.txt'"), log
    assert log.include?('fatal: pathspec'), log
    assert log.include?("$?.exitstatus=128"), log
  end

  test '[git add] succeeds silently' do
    ok { git.init(path, '') }
    write_file
    silent_ok { git.add(path, filename) }
  end

  test '[git commit] succeeds non-silently' do
    ok { git.init(path, '') }
    write_file
    ok { git.add(path, filename) }
    message = ok { git.commit(path, '-am "one"') }
    assert message.include?("create mode 100644 #{filename}")
  end

  test '[git rm] succeeds non-silently' do
    ok { git.init(path, '') }
    write_file
    ok { git.add(path, filename) }
    ok { git.commit(path, '-am "one"') }
    message = ok { git.rm(path, filename) }
    assert message.start_with?("rm '#{filename}'")
  end

  test '[git show tag:filename] is content of filename for that tag' do
    ok { git.init(path, '') }
    content = 'greetings'
    write_file(content)
    ok { git.add(path, filename) }
    ok { git.commit(path, '-am "one"') }
    ok { git.tag(path, "-m '1' 1 HEAD") }
    message = ok { git.show(path, "1:#{filename}") }
    assert_equal content, message
  end

  test '[git diff was_tag now_tag] is raw git diff output' do
    ok { git.init(path, '') }
    old_content = 'aaaaa'
    write_file(old_content)
    ok { git.add(path, filename) }
    ok { git.commit(path, '-am "one"') }
    ok { git.tag(path, "-m '1' 1 HEAD") }
    ok { git.show(path, "1:#{filename}") }
    new_content = 'bbbbb'
    write_file(new_content)
    ok { git.add(path, filename) }
    ok { git.commit(path, '-am "two"') }
    ok { git.tag(path, "-m '2' 2 HEAD") }
    diff = git.diff(path, '1 2')
    assert diff.include?("diff --git a/#{filename} b/#{filename}")
    assert diff.include?("--- a/#{filename}")
    assert diff.include?("+++ b/#{filename}")
    assert diff.include?('-' + old_content)
    assert diff.include?('+' + new_content)
  end

  test '[git gc] succeeds silently' do
    ok { git.init(path, '') }
    silent_ok { git.gc(path, '--auto --quiet') }
  end
  
  # - - - - - - - - - - - - - - - - - -

  def path
    @path
  end
  
  def set_path(value)
    @path = value
  end
    
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
    git.log.inspect
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
