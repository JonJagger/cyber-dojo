require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/language_fileset_tests.rb

class LanguageFileSetTests < ActionController::TestCase

  Root_test_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Dir.getwd + '/' + Root_test_folder,
      :filesets_root => Dir.getwd + '/../filesets'
    }
  end
  
  def test_that_initial_fileset_for_all_languages_is_green_passed
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    FileSet.new(dojo.filesets_root, 'language').choices.each do |language|    
      avatar = Avatar.new(dojo, nil, { 'language' => language })    
      manifest = {}
      avatar.read_manifest(manifest)
      increments = avatar.run_tests(manifest)
      info = avatar.name + ', ' + language + ', green'
      assert_equal :passed, increments.last[:outcome], info
      p language + ', green(:passed) as expected'      
    end
  end

  Test_files = { 
    'C' => 'untitled.tests.c',
    'C#' => 'UntitledTest.cs',
    'C++' => 'untitled.tests.cpp',
    'Java' => 'UntitledTest.java',
    'Javascript' => 'untitled_test.js',
    'Objective C' => 'untitled_tests.m',
    'Perl' => 'untitled.t',
    'PHP' => 'UntitledTest.php',
    'Python' => 'test_untitled.py',
    'Ruby' => 'test_untitled.rb'
    
  }
  
  def test_that_altering_42_to_41_for_all_languages_is_red_failed
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    
    Test_files.each do |language,filename|
      avatar = Avatar.new(dojo, nil, { 'language' => language })
      info = avatar.name + ', ' + language
      manifest = {}
      avatar.read_manifest(manifest)
      test_code = manifest[:visible_files][filename][:content]
      manifest[:visible_files][filename][:content] = test_code.sub('42', '41')
      increments = avatar.run_tests(manifest)
      assert_equal :failed, increments.last[:outcome], info  + ', red'
      p language + ', red(:failed) as expected'      
    end
  end
    
  def test_that_altering_42_to_4s1_for_all_languages_is_amber_error
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    
    Test_files.each do |language,filename|
      avatar = Avatar.new(dojo, nil, { 'language' => language })
      info = avatar.name + ', ' + language
      manifest = {}
      avatar.read_manifest(manifest)
      test_code = manifest[:visible_files][filename][:content]
      manifest[:visible_files][filename][:content] = test_code.sub('42', '4s1')
      increments = avatar.run_tests(manifest)
      assert_equal :error, increments.last[:outcome], info  + ', amber'
      p language + ', amber(:error) as expected'      
    end
  end
  
end
