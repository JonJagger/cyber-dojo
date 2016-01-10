#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'
require_relative '../app_models/delta_maker'

class HostDiskKatasTests < LibTestBase

  def setup
    super
    set_runner_class('StubRunner')
  end

  test 'B55710',
  'katas-path has correct format when set with trailing slash' do
    path = '/tmp/slashed/'
    set_katas_root(path)
    assert_equal path, katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test 'B2F787',
  'katas-path has correct format when set without trailing slash' do
    path = '/tmp/unslashed'
    set_katas_root(path)
    assert_equal path + '/', katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test '6F3999',
  'kata-path has correct format' do
    kata = make_kata
    assert correct_path_format?(kata)
  end

  #- - - - - - - - - - - - - - - -

  test '1E4B7A',
  'kata-path is split ala git' do
    kata = make_kata
    split = kata.id[0..1] + '/' + kata.id[2..-1]
    assert path_of(kata).include?(split)
  end

  #- - - - - - - - - - - - - - - -

  test '2ED22E',
  "avatar-path has correct format" do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert correct_path_format?(avatar)
  end

  #- - - - - - - - - - - - - - - -

  test 'B7E4D5',
  'sandbox-path has correct format' do
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

  #- - - - - - - - - - - - - - - -

  test '2D9F15',
  'sandbox dir is initially created' do
    kata = make_kata
    avatar = kata.start_avatar(['hippo'])
    assert katas.dir(avatar.sandbox).exists?
  end

  #- - - - - - - - - - - - - - - -

  test '4C08A1',
  'start_avatar on multiple threads doesnt start the same avatar twice' do
    # Have to call setup at the start of each loop
    # And have to make sure setups/teardowns balance.
    # See test/test_external_helpers.rb
    teardown
    repeat = 20
    repeat.times do |n|
      begin
        setup
        kata = make_kata
        started = []
        semaphore = Mutex.new
        size = 4
        animals = Avatars.names[0...size].shuffle
        threads = Array.new(size * 2)
        names = Array.new(size * 2)
        threads.size.times { |i|
          threads[i] = Thread.new {
            avatar = kata.start_avatar(animals)
            names[i] = avatar.name unless avatar.nil?
          }
        }
        threads.size.times { |i| threads[i].join }
        names.compact!
        assert_equal animals.sort, names.sort
        assert_equal names.sort, kata.avatars.map(&:name).sort
      ensure
        teardown if n != (repeat-1)
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A31DC1',
  'start_avatar on multiple processes doesnt start the same avatar twice' do
    # Have to call setup at the start of each loop
    # And have to make sure setups/teardowns balance.
    # See test/test_external_helpers.rb
    teardown
    repeat = 20
    20.times do |n|
      begin
        setup
        kata = make_kata
        started = []
        size = 4
        animals = Avatars.names[0...size].shuffle
        names = Array.new(size * 2)
        read_pipe, write_pipe = IO.pipe
        names.size.times {
          Process.fork {
            avatar = kata.start_avatar(animals)
            write_pipe.puts avatar.name unless avatar.nil?
          }
        }
        names.size.times { Process.wait }
        write_pipe.close
        names = read_pipe.read.split
        read_pipe.close
        assert_equal animals.sort, names.sort
        assert_equal names.sort, kata.avatars.map(&:name).sort
      ensure
        teardown if n != (repeat-1)
      end
    end
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
