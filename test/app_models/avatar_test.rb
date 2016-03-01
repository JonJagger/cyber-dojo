#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'
require_relative './delta_maker'

class AvatarTest < AppModelsTestBase

  prefix = 'FB7'

  test prefix+'E81',
  "an avatar's kata is the kata it was created with" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal kata, avatar.kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'D2B',
  "an avatar's' initial visible_files are:",
  '1. the language visible_files,',
  '2. the exercise instructions,',
  '3. empty output' do
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

  test prefix+'92F',
  'when an avatar has zero traffic-lights it is not active?' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal [], lion.lights
    refute lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'BAB',
  'when an avatar has one or more traffic-lights it is active?' do
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

  test prefix+'0CA',
  'test() output is added to visible_files' do
    kata = make_kata
    @avatar = kata.start_avatar
    visible_files = @avatar.visible_files
    assert visible_files.keys.include?('output')
    assert_equal '', visible_files['output']
    runner.stub_run_output(@avatar, expected = 'helloWorld')
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert @visible_files.keys.include?('output')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'E11',
  'test() does not truncate output less than or equal to 10K characters' do
    kata = make_kata
    @avatar = kata.start_avatar
    big = 'X' * 10*1024
    runner.stub_run_output(@avatar, big)
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    assert_file 'output', big
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'E5A',
  'test() truncates output greater 10K characters' do
    kata = make_kata
    @avatar = kata.start_avatar
    big = 'X' * 10*1024
    runner.stub_run_output(@avatar, big + 'truncated')
    _, @visible_files, @output = DeltaMaker.new(@avatar).run_test
    message = 'output truncated by cyber-dojo server'
    assert_file 'output', big + "\n" + message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'925',
  'test():delta[:changed] files are changed' do
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

  test prefix+'749',
  'test():delta[:unchanged] files are unchanged' do
    kata = make_kata
    @avatar = kata.start_avatar
    filename = 'hiker.c'
    assert @avatar.visible_filenames.include? filename
    content = @avatar.visible_files[filename]
    maker = DeltaMaker.new(@avatar)
    _, @visible_files, _ = maker.run_test
    assert_file filename, content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'683',
  'test():delta[:new] files are created' do
    kata = make_kata
    @avatar = kata.start_avatar
    maker = DeltaMaker.new(@avatar)
    filename = 'new_file.c'
    content = 'once upon a time'
    maker.new_file(filename, content)
    _, @visible_files, _ = maker.run_test
    assert_file filename, content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'DEC',
  'diff(was_tag, now_tag) returns sandbox/git-diff output' do
    set_runner_class('DockerTarPipeRunner')
    kata = make_kata( { language: 'C (gcc)-assert' })
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

  private # - - - - - - - - - - - - - - - - - - - - - - -

  def hiker_c; 'hiker.c'; end

  def assert_file(filename, expected)
    assert_equal(expected, @output) if filename == 'output'
    assert_equal expected, @visible_files[filename], 'returned_to_browser'
    assert_equal expected, @avatar.visible_files[filename], 'saved_to_manifest'
  end

  def assert_log_include?(command)
    assert log.include?(command), lines_of(log)
  end

  def lines_of(log)
    log.messages.join("\n")
  end

end

