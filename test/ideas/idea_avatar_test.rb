#!/bin/bash ../test_wrapper.sh

# Idea is to rewrite tests to be more BDD like

require_relative '../test_coverage'
require_relative '../all'

gem "minitest"
require 'minitest/autorun'

require_relative 'DeltaMaker'
require_relative '../../lib/UniqueId'

module IdeaBase # mix-in

  module_function

  def set_runner_class_name(value)    ENV['CYBER_DOJO_RUNNER_CLASS_NAME']   = value; end
  def set_disk_class_name(value);     ENV['CYBER_DOJO_DISK_CLASS_NAME']     = value; end
  def set_git_class_name(value);      ENV['CYBER_DOJO_GIT_CLASS_NAME']      = value; end
  def set_one_self_class_name(value); ENV['CYBER_DOJO_ONE_SELF_CLASS_NAME'] = value; end

  def setup_env
    set_runner_class_name   'RunnerStub'
    set_disk_class_name     'DiskStub'      # DiskFake would be faster but lots of tests...
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
  end

  def create_kata(options = {})
    language = languages[options[:language] || 'C (gcc)-assert']
    exercise = exercises[options[:exercise] || 'Fizz_Buzz']
    id = options[:id] || unique_id
    @kata = katas.create_kata(language, exercise, id)
  end
  
  def kata; @kata; end

  def language
    @kata.language
  end

  def start_avatar
    @avatar = @kata.start_avatar
    @maker = DeltaMaker.new(@avatar)
    stub_output('any')
  end

  def avatar; @avatar; end

  def sandbox
    avatar.sandbox
  end

  def stub_output(s)
    runner.stub_output(s)
  end

  def new_file(filename, content)
    @maker.new_file(filename,content)
  end

  def change_file(filename, content)
    @maker.change_file(filename,content)
  end

  def delete_file(filename)
    @maker.delete_file(filename)
  end

  def run_test
    @delta,@visible_files,@output = @maker.run_test
    @maker = DeltaMaker.new(@avatar)
  end
    
  include UniqueId
  
  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def katas;     dojo.katas;     end
  def runner;    dojo.runner;    end
  def git;       dojo.git;       end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

class IdeaAvatarTests < MiniTest::Test

  include IdeaBase

  def setup
    super
    setup_env
    create_kata
    start_avatar
  end
     
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'test() does NOT append commented master version to cyber-dojo.sh' +
       ' nor prepends an alert to the output when avatars cyber-dojo.sh is' +
       ' *stripped* version of master which has blank lines' do
    create_kata({ :language => 'C (gcc)-assert' })
    start_avatar

    master = language.visible_files[cyber_dojo_sh]
    assert master.split.size === 2
    stripped_master = master.strip
    assert stripped_master.split("\n").size === 1

    change_file(cyber_dojo_sh, stripped_master)    
    stub_output(radiohead = 'no alarms and no surprises')
    run_test
    assert_file cyber_dojo_sh, stripped_master
    assert_file 'output', radiohead
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() saves changed makefile with leading spaces converted to tabs' +
       ' and these changes are made to the visible_files parameter too' +
       ' so they also occur in the manifest file' do
    change_file(makefile, makefile_with_leading_spaces)
    run_test
    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test() saves *new* makefile with leading spaces converted to tabs' +
       ' and these changes are made to the visible_files parameter too' +
       ' so they also occur in the manifest file' do
    delete_file(makefile)
    run_test
    new_file(makefile, makefile_with_leading_spaces)
    run_test
    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:changed] files are saved' do
    change_file(code_filename = 'hiker.c', new_code = 'changed content for code file')
    run_test
    assert_file code_filename, new_code
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:unchanged] files are not saved' do
    assert sandbox.dir.exists? hiker_c
    sandbox.dir.delete(hiker_c)
    refute sandbox.dir.exists? hiker_c
    run_test
    refute sandbox.dir.exists? hiker_c
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test():delta[:new] files are saved and git added' do
    new_filename = 'ab.c'
    refute git_log_include?(sandbox.path, ['add', "#{new_filename}"])
    refute sandbox.dir.exists?(new_filename)
    new_file(new_filename, new_content = 'content for new file')
    run_test
    assert git_log_include?(sandbox.path, ['add', "#{new_filename}"])
    assert_file new_filename, new_content
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:deleted] files are git rm'd" do
    delete_file(makefile)
    run_test
    assert git_log_include?(sandbox.path, [ 'rm', makefile ])
    refute_file makefile
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cyber_dojo_sh; 'cyber-dojo.sh'; end
  def makefile; 'makefile'; end
  def hiker_c; 'hiker.c'; end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_file(filename, expected)
    assert_equal(expected, @output, 'output') if filename === 'output'
    assert_equal expected, @visible_files[filename],       'returned_to_browser'
    assert_equal expected, avatar.visible_files[filename], 'saved_to_manifest'
    assert_equal expected, sandbox.read(filename),         'saved_to_sandbox'
  end
  
  def refute_file(filename)
    refute @visible_files.keys.include?(filename),      'returned to browser'
    refute avatar.visible_filenames.include?(filename), 'saved to manifest'
    refute sandbox.dir.exists?(filename),               'saved to sandbox'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def git_log_include?(path,find)
    git.log[path].include?(find)
  end

end
