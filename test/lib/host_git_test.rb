#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostGitTest < LibTestBase

  def setup
    super
    set_shell_class('MockHostShell')
  end

  def teardown
    shell.teardown
    super
  end

  # - - - - - - - - - - - - - - - - -

  test '6F8B85',
  'shell.cd_exec for git.show' do
    options = '--quiet'
    expect(["git show #{options}"])
    git.show(path, options)
  end

  # - - - - - - - - - - - - - - - - -

  test '31A9A2',
  'shell.cd_exec for git.diff' do
    was_tag = 2
    now_tag = 3
    options = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    expect(["git diff #{options}"])
    git.diff(path, was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - -

  test 'DC30B4',
  'shell.cd_exec for git.setup' do
    user_name = 'lion'
    user_email = 'lion@cyber-dojo.org'
    expect([
      'git init --quiet',
      "git config user.name '#{user_name}'",
      "git config user.email '#{user_email}'"
    ])
    git.setup(path, user_name, user_email)
  end

  # - - - - - - - - - - - - - - - - -

  test '7A3E16',
  'shell.cd_exec for git.rm' do
    filename = 'wibble.c'
    expect(["git rm '#{filename}'"])
    git.rm(path, filename)
  end

  # - - - - - - - - - - - - - - - - -

  test 'F2FAD5',
  'shell.cd_exec for git.add' do
    filename = 'wibble.h'
    expect(["git add '#{filename}'"])
    git.add(path, filename)
  end

  # - - - - - - - - - - - - - - - - -

  test 'F728AB',
  'shell.cd_exec for git.commit' do
    tag = 6
    expect([
      "git commit -a -m #{tag} --quiet",
      'git gc --auto --quiet',
      "git tag -m '#{tag}' #{tag} HEAD"
    ])
    git.commit(path, tag)
  end

  private

  def expect(shell_commands)
    shell.mock_cd_exec(path, shell_commands, 'output', shell.success)
  end

  def path
    'a/b/c/'
  end

end
