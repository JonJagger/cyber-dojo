#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'
require_relative 'DeltaMaker'

class AvatarTests < ModelTestBase

  include TimeNow

  test 'path(avatar)' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert path_ends_in_slash?(avatar)
    assert path_has_no_adjacent_separators?(avatar)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'attempting to create an Avatar with an invalid name raises RuntimeError' do
    kata = katas[unique_id]
    invalid_name = 'mobilephone'
    refute Avatars.names.include?(invalid_name)
    assert_raises(RuntimeError) { kata.avatars[invalid_name] }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar returns kata it was created with" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal kata, avatar.kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created its sandbox contains each visible_file" do
    kata = make_kata
    avatar = kata.start_avatar
    kata.language.visible_files.each do |filename,content|
      assert_equal content, avatar.sandbox.read(filename)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  test 'avatar is not active? when it does not exist' do
    kata = katas[unique_id]
    lion = kata.avatars['lion']
    refute lion.exists?
    refute lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar is not active? when it has zero traffic-lights' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal [ ], lion.lights
    refute lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar is active? when it has one traffic-light' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    runner.stub_output('')
    DeltaMaker.new(lion).run_test
    assert_equal 1, lion.lights.length
    assert lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is true when dir exists and name is in Avatar.names' do
    kata = katas[unique_id]
    lion = kata.avatars['lion']
    refute lion.exists?
    lion.dir.make
    assert lion.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'after avatar is started its visible_files are:' +
       ' 1. the language visible_files,' +
       ' 2. the exercse instructions,' +
       ' 3. empty output' do
    kata = make_kata
    language = kata.language
    avatar = kata.start_avatar
    language.visible_files.each do |filename,content|
      assert avatar.visible_filenames.include?(filename)
      assert_equal avatar.visible_files[filename], content
    end
    assert avatar.visible_filenames.include? 'instructions'
    assert avatar.visible_files['instructions'].include? kata.exercise.instructions
    assert avatar.visible_filenames.include? 'output'
    assert_equal '',avatar.visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar creation saves' +
          ' each visible_file into sandbox/,' +
          ' and empty increments.json into avatar/' do
    kata = make_kata
    avatar = kata.start_avatar
    kata.language.visible_files.each do |filename,content|
      assert_equal content, avatar.sandbox.read(filename)
    end
    assert_equal [ ], JSON.parse(avatar.read('increments.json'))
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'after test() output-file is saved in sandbox/' +
       ' and output is inserted into the visible_files' do
    kata = make_kata
    @avatar = kata.start_avatar
    visible_files = @avatar.visible_files
    assert visible_files.keys.include?('output')
    assert_equal '',visible_files['output']

    runner.stub_output(expected = 'helloWorld')
    _,@visible_files,@output = DeltaMaker.new(@avatar).run_test

    assert @visible_files.keys.include?('output')
    assert_file 'output', expected
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() on master cyber-dojo.sh results in standard output' +
       ' with no ALERT, and no modification to any cyber-dojo.sh' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    master = @avatar.visible_files[cyber_dojo_sh]

    runner.stub_output(expected = 'no alarms and no surprises')
    _,@visible_files,@output = DeltaMaker.new(@avatar).run_test

    assert_file 'output', expected
    assert_file cyber_dojo_sh, master
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() on commented master cyber-dojo.sh results in standard output' +
       ' with no ALERT, and no modification to any cyber-dojo.sh' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    maker = DeltaMaker.new(@avatar)
    commented_master = commented(maker.was[cyber_dojo_sh])
    maker.change_file(cyber_dojo_sh, commented_master)

    runner.stub_output(expected = 'no alarms and no surprises')
    _,@visible_files,@output = maker.run_test

    assert_file 'output', expected
    assert_file cyber_dojo_sh, commented_master
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() sees changed cyber-dojo.sh file and appends' +
       ' info plus commented master version to cyber-dojo.sh' +
       ' and prepends an alert to the output. And it does all' +
       ' this only *once*' do
    kata = make_kata(unique_id, 'Java-JUnit')
    @avatar = kata.start_avatar
    language = @avatar.kata.language
    master = @avatar.visible_files[cyber_dojo_sh]
    assert master.split.size > 1

    maker = DeltaMaker.new(@avatar)
    maker.change_file(cyber_dojo_sh, first_content = "hello\nworld")
    runner.stub_output(radiohead = 'no alarms and no surprises')
    _,@visible_files,@output = maker.run_test

    separator = "\n\n"
    expected_output = @avatar.kata.language.output_alert + separator + radiohead
    assert_file 'output', expected_output

    appended_commented_master =
      first_content +
      separator +
      language.cyber_dojo_sh_alert +
      separator +
      commented(master)

    assert_file cyber_dojo_sh, appended_commented_master

    # --- only once ---

    runner.stub_output(radiohead)
    _,@visible_files,@output = DeltaMaker.new(@avatar).run_test

    assert_file 'output', radiohead
    assert_file cyber_dojo_sh, appended_commented_master
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() does NOT append commented master version to cyber-dojo.sh' +
       ' nor prepends an alert to the output when cyber-dojo.sh is' +
       ' stripped version of one-liner' do
    kata = make_kata(unique_id, 'C (gcc)-assert')
    @avatar = kata.start_avatar
    language = @avatar.kata.language
    master = @avatar.visible_files[cyber_dojo_sh]
    assert master.split.size === 2
    stripped_master = master.strip
    assert stripped_master.split("\n").size === 1

    runner.stub_output(radiohead = 'no alarms and no surprises')
    maker = DeltaMaker.new(@avatar)
    maker.change_file(cyber_dojo_sh, stripped_master)
    _,@visible_files,@output = maker.run_test

    assert_file 'output', radiohead
    assert_file cyber_dojo_sh, stripped_master
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() saves changed makefile with leading spaces converted to tabs' +
       ' and these changes are made to the visible_files parameter too' +
       ' so they also occur in the manifest file' do
    kata = make_kata
    @avatar = kata.start_avatar

    runner.stub_output('hello')
    maker = DeltaMaker.new(@avatar)
    maker.change_file(makefile, makefile_with_leading_spaces)
    _,@visible_files,_ = maker.run_test

    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() saves *new* makefile with leading spaces converted to tabs' +
       ' and these changes are made to the visible_files parameter too' +
       ' so they also occur in the manifest file' do
    kata = make_kata
    @avatar = kata.start_avatar

    runner.stub_output('hello')
    maker = DeltaMaker.new(@avatar)
    maker.delete_file(makefile)
    _,@visible_files,_ = maker.run_test

    runner.stub_output('hello')
    maker = DeltaMaker.new(@avatar)
    maker.new_file(makefile, makefile_with_leading_spaces)
    _,@visible_files,_ = maker.run_test

    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:changed] files are saved' do
    kata = make_kata
    @avatar = kata.start_avatar
    code_filename = 'hiker.c'
    test_filename = 'hiker.tests.c'

    maker = DeltaMaker.new(@avatar)
    maker.change_file(code_filename, new_code='changed content for code file')
    maker.change_file(test_filename, new_test='changed content for test file')
    runner.stub_output('')
    _,@visible_files,_ = maker.run_test

    assert_file code_filename, new_code
    assert_file test_filename, new_test
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:unchanged] files are not saved' do
    kata = make_kata
    avatar = kata.start_avatar
    assert avatar.visible_filenames.include? hiker_c
    assert avatar.sandbox.dir.exists? hiker_c

    # dir.delete(filename) only exists on DirFake not on HostDir
    avatar.sandbox.dir.delete(hiker_c)
    refute avatar.sandbox.dir.exists? hiker_c

    runner.stub_output('')
    avatar.test(*DeltaMaker.new(avatar).test_args)

    refute avatar.sandbox.dir.exists? hiker_c
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:new] files are saved and git added' do
    kata = make_kata
    @avatar = kata.start_avatar
    new_filename = 'ab.c'

    refute git_log_include?(@avatar.sandbox.path, ['add', "#{new_filename}"])
    refute @avatar.sandbox.dir.exists?(new_filename)

    runner.stub_output('')
    maker = DeltaMaker.new(@avatar)
    maker.new_file(new_filename, new_content = 'content for new file')
    _,@visible_files,_ = maker.run_test

    assert git_log_include?(@avatar.sandbox.path, ['add', "#{new_filename}"])
    assert_file new_filename, new_content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:deleted] files are git rm'd" do
    kata = make_kata
    @avatar = kata.start_avatar
    runner.stub_output('')
    maker = DeltaMaker.new(@avatar)
    maker.delete_file(makefile)
    _,@visible_files,_ = maker.run_test

    assert git_log_include?(@avatar.sandbox.path, [ 'rm', makefile ])
    refute @visible_files.keys.include? makefile
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tag.diff' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    fake_three_tests(lion)
    manifest = JSON.unparse({
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#ifndef HIKER_INCLUDED_H\n#endif',
      'output' => 'unterminated conditional directive'
    })
    filename = 'manifest.json'
    git.spy(lion.dir.path,'show',"#{3}:#{filename}",manifest)
    stub_diff = [
      "diff --git a/sandbox/hiker.h b/sandbox/hiker.h",
      "index e69de29..f28d463 100644",
      "--- a/sandbox/hiker.h",
      "+++ b/sandbox/hiker.h",
      "@@ -1 +1,2 @@",
      "-#ifndef HIKER_INCLUDED",
      "\\ No newline at end of file",
      "+#ifndef HIKER_INCLUDED_H",
      "+#endif",
      "\\ No newline at end of file"
    ].join("\n")
    git.spy(lion.dir.path,
      'diff',
      '--ignore-space-at-eol --find-copies-harder 2 3 sandbox',
      stub_diff)

    tags = lion.tags
    actual = lion.diff(2,3) #tags[2].diff(3)
    expected =
    {
      "hiker.h" =>
      [
        { :type => :section, :index => 0 },
        { :type => :deleted, :line => "#ifndef HIKER_INCLUDED", :number => 1 },
        { :type => :added,   :line => "#ifndef HIKER_INCLUDED_H", :number => 1 },
        { :type => :added,   :line => "#endif", :number => 2 }
      ],
      "hiker.c" =>
      [
        { :line => "#include \"hiker.h\"", :type => :same, :number => 1 }
      ],
      "output" =>
      [
        { :line => "unterminated conditional directive", :type => :same, :number => 1 }
      ]
    }
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - -

  def makefile_with_leading_tab
    makefile_with_leading("\t")
  end

  def makefile_with_leading_spaces
    makefile_with_leading(' ' + ' ')
  end

  def makefile_with_leading(s)
    [
      "CFLAGS += -I. -Wall -Wextra -Werror -std=c11",
      "test: makefile $(C_FILES) $(COMPILED_H_FILES)",
      s + "@gcc $(CFLAGS) $(C_FILES) -o $@"
    ].join("\n")
  end

  #- - - - - - - - - - - - - - - - - - -

  def fake_three_tests(avatar)
    incs =
    [
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 55, 7],
        'number' => 3
      }
    ]
    avatar.dir.write('increments.json', incs)
  end

  #- - - - - - - - - - - - - - - - - - -

  def commented(lines)
    lines.split("\n").map{ |line| '#' + line }.join("\n")
  end

  def cyber_dojo_sh; 'cyber-dojo.sh'; end
  def makefile; 'makefile'; end
  def hiker_c; 'hiker.c'; end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_file(filename, expected)
    assert_equal(expected, @output) if filename === 'output'
    assert_equal expected, @visible_files[filename], 'returned_to_browser'
    assert_equal expected, @avatar.visible_files[filename], 'saved_to_manifest'
    assert_equal expected, @avatar.sandbox.read(filename), 'saved_to_sandbox'
  end

  def git_log_include?(path,find)
    git.log[path].include?(find)
  end

end
