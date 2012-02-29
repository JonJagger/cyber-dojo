require File.dirname(__FILE__) + '/../test_helper'
require 'CodeRunner'

# > ruby test/functional/code_runner_tests.rb

class CodeRunnerTests < ActionController::TestCase

  ROOT_TEST_DIR = RAILS_ROOT + '/test/code_runner'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end
  
  def test_visible_and_hidden_files_are_copied_to_sandbox_and_output_is_generated
    root_test_dir_reset
    language = 'Dummy'
    
    temp_dir = '12345678'
    sandbox_dir = ROOT_TEST_DIR + '/' + temp_dir    
    language_dir = RAILS_ROOT +  '/test/functional/filesets/language/' + language
    fileset = LanguageFileSet.new(language_dir)
    visible_files = fileset.visible_files
    
    Dir.mkdir sandbox_dir    
    output = CodeRunner::inner_run(sandbox_dir, language_dir, visible_files)
    
    assert_equal true, File.exists?(sandbox_dir), "sandbox dir created"
    
    visible_files.each do |filename,content|
      assert_equal true, File.exists?(sandbox_dir + '/' + filename), "File.exists? #{sandbox_dir}/#{filename}"
    end
    
    fileset.hidden_filenames.each do |filename|
      assert_equal true, File.exists?(sandbox_dir + '/' + filename), "File.exists? #{sandbox_dir}/#{filename}"
    end
    
    assert_equal true, output != nil, "output != nil"
    assert_equal true, output.include?('<54> expected but was'), "output.include?('<54>...')"
  end    
      
  def test_sandbox_dir_is_deleted_after_run
    root_test_dir_reset
    language = 'Dummy'
    
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    sandbox_dir = ROOT_TEST_DIR + '/' + temp_dir    
    language_dir = RAILS_ROOT +  '/test/functional/filesets/language/' + language
    
    fileset = LanguageFileSet.new(language_dir)
    visible_files = fileset.visible_files
    
    output = CodeRunner::run(sandbox_dir, language_dir, visible_files)
    assert_equal true, output != nil, "output != nil"
    assert_equal true, output.class == String, "output.class == String"
    assert_equal true, output.include?('<54> expected but was'), "output.include?('<54>...')"
    
    assert_equal true, !File.exists?(sandbox_dir), "!File.exists?(#{sandbox_dir})"
  end
      
end

