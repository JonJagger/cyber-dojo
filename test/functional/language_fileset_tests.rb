require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/language_fileset_tests.rb

class LanguageFileSetTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params_name(language)
    { :dojo_name => language, 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT + '/filesets',
      'language' => language,
      'kata' => 'Prime Factors',
      :browser => 'None (test)'
    }
  end

  Code_files = { 
    'C' => 'untitled.c',
    'C#' => 'Untitled.cs',
    'C++' => 'untitled.cpp',
    'Erlang' => 'untitled.erl',
    'Haskell' => 'Untitled.hs',
    'Java' => 'Untitled.java',
    'Javascript' => 'untitled.js',
    'Perl' => 'untitled.perl',
    'PHP' => 'Untitled.php',
    'Python' => 'untitled.py',
    'Ruby' => 'untitled.rb'    
  }
  
  def test_that_initial_fileset_for_all_languages_is_red_failed
    Code_files.each do |language,filename|
      root_test_folder_reset
      params = make_params_name(language)
      assert Dojo::create(params)
      assert Dojo::configure(params)
      dojo = Dojo.new(params)
      avatar_name = Avatar::names.shuffle[0]
      avatar = Avatar.new(dojo, avatar_name)
      manifest = avatar.manifest
      avatar.run_tests(manifest)
      info = avatar.name + ', ' + language
      assert_equal :failed, avatar.increments.last[:outcome], info + ', red,' + manifest[:output]
      print '.'      
    end    
  end    

  def test_that_altering_42_to_54_for_all_languages_is_green_passed
    Code_files.each do |language,filename|
      root_test_folder_reset
      params = make_params_name(language)
      assert Dojo::create(params)
      assert Dojo::configure(params)
      dojo = Dojo.new(params)
      avatar_name = Avatar::names.shuffle[0]
      avatar = Avatar.new(dojo, avatar_name)
      manifest = avatar.manifest
        test_code = manifest[:visible_files][filename][:content]
        manifest[:visible_files][filename][:content] = test_code.sub('42', '54')
      avatar.run_tests(manifest)
      info = avatar.name + ', ' + language
      assert_equal :passed, avatar.increments.last[:outcome], info  + ', green,' + manifest[:output]
      print '.'      
    end    
  end    
      
  def test_that_altering_42_to_4typo2_for_all_languages_is_amber_error
    Code_files.each do |language,filename|
      root_test_folder_reset
      params = make_params_name(language)
      assert Dojo::create(params)
      assert Dojo::configure(params)
      dojo = Dojo.new(params)
      avatar_name = Avatar::names.shuffle[0]
      avatar = Avatar.new(dojo, avatar_name)
      manifest = avatar.manifest
        test_code = manifest[:visible_files][filename][:content]
        manifest[:visible_files][filename][:content] = test_code.sub('42', '4typo2')
      avatar.run_tests(manifest)
      info = avatar.name + ', ' + language
      assert_equal :error, avatar.increments.last[:outcome], info  + ', amber,' + manifest[:output]
      print '.'      
    end    
  end
      
end
