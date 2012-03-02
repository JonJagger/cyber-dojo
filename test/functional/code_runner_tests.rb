require File.dirname(__FILE__) + '/../test_helper'
require 'CodeRunner'

# > ruby test/functional/code_runner_tests.rb

class CodeRunnerTests < ActionController::TestCase

  TEST_ROOT_DIR = RAILS_ROOT + '/test/cyberdojo'
  
  def setup
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    @sandbox_dir = TEST_ROOT_DIR + '/sandboxes/' + temp_dir
    Dir.mkdir @sandbox_dir
  end
  
  def teardown
    `rm -rf #{@sandbox_dir}`
    @sandbox_dir = nil
  end

  test "visible and hidden files are copied to sandbox and output is generated" do
    language_dir = TEST_ROOT_DIR +  '/languages/Dummy'
    fileset = LanguageFileSet.new(language_dir)
    visible_files = fileset.visible_files    
    output = CodeRunner::inner_run(@sandbox_dir, language_dir, visible_files)
    
    assert File.exists?(@sandbox_dir), "sandbox dir created"
    
    visible_files.each do |filename,content|
      assert File.exists?(@sandbox_dir + '/' + filename),
            "File.exists?(#{@sandbox_dir}/#{filename})"
    end
    
    fileset.hidden_filenames.each do |filename|
      assert File.exists?(@sandbox_dir + '/' + filename),
            "File.exists?(#{@sandbox_dir}/#{filename})"
    end
    
    assert_not_nil output, "output != nil"
    assert output.include?('<54> expected but was'), "output.include?('<54>...')"
  end    
      
  test "sandbox dir is deleted after run" do
    `rm -rf #{@sandbox_dir}`
    language_dir = TEST_ROOT_DIR +  '/languages/Dummy'    
    visible_files = LanguageFileSet.new(language_dir).visible_files
    
    output = CodeRunner::run(@sandbox_dir, language_dir, visible_files)
    assert_not_nil output, "output != nil"
    assert output.class == String, "output.class == String"
    assert output.include?('<54> expected but was'), "output.include?('<54>...')"
    assert !File.exists?(@sandbox_dir),
          "!File.exists?(#{@sandbox_dir})"
  end
      
end

