#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'
require_relative './delta_maker'

class AvatarTests < AppModelTestBase

  test '2ED22E',
  "an avatar's path has correct format" do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert correct_path_format?(avatar)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4C9E81',
  "an avatar's kata is the kata it was created with" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal kata, avatar.kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F70D2B',
    "an avatar's' initial visible_files are:" +
       ' 1. the language visible_files,' +
       ' 2. the exercise instructions,' +
       ' 3. empty output' do
    kata = make_kata
    language = kata.language
    avatar = kata.start_avatar
    language.visible_files.each do |filename, content|
      assert avatar.visible_filenames.include?(filename)
      assert_equal avatar.visible_files[filename], content
    end
    assert avatar.visible_filenames.include? 'instructions'
    assert avatar.visible_files['instructions'].include? kata.exercise.instructions
    assert avatar.visible_filenames.include? 'output'
    assert_equal '', avatar.visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E4EB88',
  'an avatar is git configured with single quoted user.name/email' do
    kata = make_kata
    salmon = kata.start_avatar(['salmon'])
    assert_log_include?("git config user.name 'salmon_#{kata.id}'")
    assert_log_include?("git config user.email 'salmon@cyber-dojo.org'")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7DD92F',
  'an avatar is not active? when it has zero traffic-lights' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal [], lion.lights
    refute lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEABAB',
  'an avatar is active? when it has one or more traffic-lights' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    DeltaMaker.new(lion).run_test
    assert_equal 1, lion.lights.length
    assert lion.active?
    DeltaMaker.new(lion).run_test
    assert_equal 2, lion.lights.length
    assert lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3FF0CA',
    'after test() output-file is saved in sandbox/' +
       ' and output is inserted into the visible_files' do
    kata = make_kata
    @avatar = kata.start_avatar
    visible_files = @avatar.visible_files
    assert visible_files.keys.include?('output')
    assert_equal '', visible_files['output']
    runner.mock_run_output(@avatar, expected = 'helloWorld')
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert @visible_files.keys.include?('output')
    assert_file 'output', expected
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EB2E11',
    'test() does not truncate output less than or equal to 10*1024 characters' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    big = 'X' * 10*1024

    runner.mock_run_output(@avatar, big)

    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert_file 'output', big
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4B2E5A',
  'test() truncates output greater 10*1024 characters' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    big = 'X' * 10*1024
    runner.mock_run_output(@avatar, big + 'truncated')
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    message = 'output truncated by cyber-dojo server'
    assert_file 'output', big + "\n" + message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '37E925',
  'test():delta[:changed] files are saved' do
    kata = make_kata
    @avatar = kata.start_avatar
    code_filename = 'hiker.c'
    test_filename = 'hiker.tests.c'

    maker = DeltaMaker.new(@avatar)
    maker.change_file(code_filename, new_code = 'changed content for code file')
    maker.change_file(test_filename, new_test = 'changed content for test file')
    _, @visible_files, _ = maker.run_test

    assert_file code_filename, new_code
    assert_file test_filename, new_test
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '83B749',
  'test():delta[:unchanged] files are not saved' do
    kata = make_kata
    avatar = kata.start_avatar
    assert avatar.visible_filenames.include? hiker_c
    assert dir_of(avatar.sandbox).exists? hiker_c

    # There is no dir.delete(filename)
    File.delete(avatar.sandbox.path + hiker_c)
    refute dir_of(avatar.sandbox).exists? hiker_c

    avatar.test(*DeltaMaker.new(avatar).test_args)

    refute dir_of(avatar.sandbox).exists? hiker_c
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8EF1A3',
  'test():delta[:new] files are saved and git added' do
    kata = make_kata
    @avatar = kata.start_avatar
    new_filename = 'ab.c'

    evidence = "git add '#{new_filename}'"
    refute_log_include?(pathed(evidence))
    refute dir_of(@avatar.sandbox).exists?(new_filename)

    maker = DeltaMaker.new(@avatar)
    maker.new_file(new_filename, new_content = 'content for new file')
    _, @visible_files, _ = maker.run_test

    assert_log_include?(pathed(evidence))
    assert_file new_filename, new_content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A66E09',
  "test():delta[:deleted] files are git rm'd" do
    kata = make_kata
    @avatar = kata.start_avatar
    maker = DeltaMaker.new(@avatar)
    maker.delete_file(makefile)
    _, @visible_files, _ = maker.run_test

    evidence = "git rm 'makefile'"
    assert_log_include?(pathed(evidence))
    refute @visible_files.keys.include? makefile
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '19CDEC',
  'diff(was_tag, now_tag) returns git-diff output' do
    kata = make_kata
    @avatar = kata.start_avatar # tag 0
    maker = DeltaMaker.new(@avatar)
    filename = 'hiker.c'
    assert maker.file?(filename)
    content = maker.content(filename)
    refute_nil content
    maker.change_file(filename, content.sub('9', '7'))
    maker.run_test # tag 1

    diff_lines = @avatar.diff(0, 1)

    assert diff_lines.include? '--- a/sandbox/hiker.c'
    assert diff_lines.include? '+++ b/sandbox/hiker.c'
    assert diff_lines.include? 'diff --git a/sandbox/hiker.c b/sandbox/hiker.c'
    assert diff_lines.include? '-    return 6 * 9;'
    assert diff_lines.include? '+    return 6 * 7;'
  end

  private

  def makefile; 'makefile'; end
  def hiker_c; 'hiker.c'; end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_file(filename, expected)
    assert_equal(expected, @output) if filename == 'output'
    assert_equal expected, @visible_files[filename], 'returned_to_browser'
    assert_equal expected, @avatar.visible_files[filename], 'saved_to_manifest'
    assert_equal expected, dir_of(@avatar.sandbox).read(filename), 'saved_to_sandbox'
  end

  def refute_log_include?(command)
    refute log.include?(command), log.to_s
  end

  def assert_log_include?(command)
    assert log.include?(command), lines_of(log)
  end

  def pathed(command)
    "cd #{@avatar.sandbox.path} && #{command}"
  end

  def lines_of(log)
    log.messages.join("\n")
  end

end

