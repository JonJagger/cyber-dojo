#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative '../app_models/delta_maker'

class HostDiskKatasTests < LibTestBase

  def setup
    super
    set_runner_class('StubRunner')
  end

  test 'B55710',
  'katas has correct path format when set with trailing slash' do
    path = '/tmp/slashed/'
    set_katas_root(path)
    assert_equal path, katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test 'B2F787',
  'katas has correct path format when set without trailing slash' do
    path = '/tmp/unslashed'
    set_katas_root(path)
    assert_equal path + '/', katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test '6F3999',
  'kata has correct path format' do
    kata = make_kata
    assert correct_path_format?(kata)
  end

  #- - - - - - - - - - - - - - - -

  test '1E4B7A',
  'path is split ala git' do
    kata = make_kata
    split = kata.id[0..1] + '/' + kata.id[2..-1]
    assert path_of(kata).include?(split)
  end

  #- - - - - - - - - - - - - - - -

  test '2ED22E',
  "avatar has correct path format" do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert correct_path_format?(avatar)
  end

  #- - - - - - - - - - - - - - - -

  test 'B7E4D5',
  'sandbox has correct path format' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    sandbox = avatar.sandbox
    assert correct_path_format?(sandbox)
    assert path_of(sandbox).include?('sandbox')
  end

  #- - - - - - - - - - - - - - - -

  test 'CE9083',
  'make_kata saves manifest in kata dir' do
    kata = make_kata
    assert katas.dir(kata).exists?('manifest.json')
  end

  #- - - - - - - - - - - - - - - -

  test '2D9F15',
  'sandbox dir is initially created' do
    kata = make_kata
    avatar = kata.start_avatar(['hippo'])
    assert katas.dir(avatar.sandbox).exists?
  end

  #- - - - - - - - - - - - - - - -

  test 'E4EB88',
  'a started avatar is git configured with single quoted user.name/email' do
    kata = make_kata
    salmon = kata.start_avatar(['salmon'])
    assert_log_include?("git config user.name 'salmon_#{kata.id}'")
    assert_log_include?("git config user.email 'salmon@cyber-dojo.org'")
  end

  #- - - - - - - - - - - - - - - -

  test '8EF1A3',
  "test():delta[:new] files are git add'ed" do
    kata = make_kata
    @avatar = kata.start_avatar
    new_filename = 'ab.c'

    git_evidence = "git add '#{new_filename}'"
    refute_log_include?(pathed(git_evidence))

    maker = DeltaMaker.new(@avatar)
    maker.new_file(new_filename, new_content = 'content for new file')
    _, @visible_files, _ = maker.run_test

    assert_log_include?(pathed(git_evidence))
    assert_file new_filename, new_content
  end

  #- - - - - - - - - - - - - - - -

  test 'A66E09',
  "test():delta[:deleted] files are git rm'ed" do
    kata = make_kata
    @avatar = kata.start_avatar
    maker = DeltaMaker.new(@avatar)
    maker.delete_file('makefile')
    _, @visible_files, _ = maker.run_test
    git_evidence = "git rm 'makefile'"
    assert_log_include?(pathed(git_evidence))
    refute @visible_files.keys.include? 'makefile'
  end

  private

  def correct_path_format?(object)
    ends_in_slash = path_of(object).end_with?('/')
    has_doubled_separator = path_of(object).scan('/' * 2).length != 0
    ends_in_slash && !has_doubled_separator
  end

  def assert_file(filename, expected)
    assert_equal expected, katas.dir(@avatar.sandbox).read(filename), 'saved_to_sandbox'
  end

  def assert_log_include?(command)
    assert log.include?(command), lines_of(log)
  end

  def refute_log_include?(command)
    refute log.include?(command), log.to_s
  end

  def lines_of(log)
    log.messages.join("\n")
  end

  def pathed(command)
    "cd #{path_of(@avatar.sandbox)} && #{command}"
  end

  def path_of(object)
    katas.path_of(object)
  end

end
