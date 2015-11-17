#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'
require_relative './delta_maker'

class AvatarTests < AppModelTestBase

  include TimeNow

  test '2ED22E',
  "avatar's path has correct format" do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert correct_path_format?(avatar)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4C9E81',
  'avatar returns kata it was created with' do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal kata, avatar.kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '50BE31',
  'after avatar is created its sandbox contains each visible_file' do
    kata = make_kata
    avatar = kata.start_avatar
    kata.language.visible_files.each do |filename, content|
      assert_equal content, dir_of(avatar.sandbox).read(filename)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7DD92F',
  'avatar is not active? when it has zero traffic-lights' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal [], lion.lights
    refute lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEABAB',
  'avatar is active? when it has one traffic-light' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    runner.stub_output('')
    DeltaMaker.new(lion).run_test
    assert_equal 1, lion.lights.length
    assert lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F70D2B',
    'after avatar is started its visible_files are:' +
       ' 1. the language visible_files,' +
       ' 2. the exercse instructions,' +
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

  test '000667',
    'avatar creation saves' +
      ' each visible_file into sandbox/,' +
      ' and empty increments.json into avatar/' do
    kata = make_kata
    avatar = kata.start_avatar
    kata.language.visible_files.each do |filename, content|
      assert_equal content, dir_of(avatar.sandbox).read(filename)
    end
    assert_equal [], dir_of(avatar).read_json('increments.json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '3FF0CA',
    'after test() output-file is saved in sandbox/' +
       ' and output is inserted into the visible_files' do
    kata = make_kata
    @avatar = kata.start_avatar
    visible_files = @avatar.visible_files
    assert visible_files.keys.include?('output')
    assert_equal '', visible_files['output']
    runner.stub_output(expected = 'helloWorld')
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert @visible_files.keys.include?('output')
    assert_file 'output', expected
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EB2E11',
    'test() does not truncate output less than or equal to 50*1024 characters' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    big = 'X' * 50*1024
    runner.stub_output(big)
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert_file 'output', big
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4B2E5A',
  'test() truncates output greater 50*1024 characters' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    big = 'X' * 50*1024
    runner.stub_output(big + 'truncated')
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
    runner.stub_output('')
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

    runner.stub_output('')
    avatar.test(*DeltaMaker.new(avatar).test_args)

    refute dir_of(avatar.sandbox).exists? hiker_c
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8EF1A3',
  'test():delta[:new] files are saved and git added' do
    kata = make_kata
    @avatar = kata.start_avatar
    new_filename = 'ab.c'

    evidence = "git add '#{new_filename}' 2>&1"
    refute git_log_include?(@avatar.sandbox.path, evidence)

    refute @avatar.sandbox.dir.exists?(new_filename)

    runner.stub_output('')
    maker = DeltaMaker.new(@avatar)
    maker.new_file(new_filename, new_content = 'content for new file')
    _, @visible_files, _ = maker.run_test

    evidence = "git add '#{new_filename}' 2>&1"
    assert git_log_include?(@avatar.sandbox.path, evidence)
    assert_file new_filename, new_content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A66E09',
  "test():delta[:deleted] files are git rm'd" do
    kata = make_kata
    @avatar = kata.start_avatar
    runner.stub_output('')
    maker = DeltaMaker.new(@avatar)
    maker.delete_file(makefile)
    _, @visible_files, _ = maker.run_test

    evidence = "git rm 'makefile' 2>&1"
    assert git_log_include?(@avatar.sandbox.path, evidence)
    refute @visible_files.keys.include? makefile
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  def fake_three_tests(avatar)
    incs =
    [
      {
        'colour' => 'red',
        'time'   => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time'   => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      {
        'colour' => 'green',
        'time'   => [2014, 2, 15, 8, 55, 7],
        'number' => 3
      }
    ]
    avatar.dir.write_json('increments.json', incs)
  end

  #- - - - - - - - - - - - - - - - - - -

  private

  def commented(lines)
    lines.split("\n").map{ |line| '#' + line }.join("\n")
  end

  def cyber_dojo_sh; 'cyber-dojo.sh'; end
  def makefile; 'makefile'; end
  def hiker_c; 'hiker.c'; end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_file(filename, expected)
    assert_equal(expected, @output) if filename == 'output'
    assert_equal expected, @visible_files[filename], 'returned_to_browser'
    assert_equal expected, @avatar.visible_files[filename], 'saved_to_manifest'
    assert_equal expected, dir_of(@avatar.sandbox).read(filename), 'saved_to_sandbox'
  end

  def git_log_include?(path, find)
    git.log.include?(find)
  end

end

