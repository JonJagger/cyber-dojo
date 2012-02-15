require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/language_file_set_red_amber_green_tests.rb

class LanguageFileSetRedAmberGreenTests < ActionController::TestCase

  Root_test_dir = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{Root_test_dir}")
    Dir.mkdir Root_test_dir
  end

  def make_params(language)
    { :kata_name => language, 
      :kata_root => Root_test_dir,
      :filesets_root => RAILS_ROOT + '/filesets',
      'language' => language,
      'exercise' => 'Prime Factors',
      :browser => 'None (test)'
    }
  end

  def make_kata(language)
    params = make_params(language)
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
    info = Kata::create_new(fileset, params)
    params[:kata_name] = info[:uuid]
    Kata.new(params)    
  end

  Code_files = { 
    'C' => 'untitled.c',
    'C++' => 'untitled.cpp',
    'Java' => 'Untitled.java',
    'Perl' => 'untitled.perl',
    'Python' => 'untitled.py',
    'Ruby' => 'untitled.rb'    
  }

  XCode_files = {  # not installed on my MacBook...
    'C#' => 'Untitled.cs',
    'Erlang' => 'untitled.erl',
    'Haskell' => 'Untitled.hs',
    'Javascript' => 'untitled.js',
    'PHP' => 'Untitled.php',
  }
  
  def test_that_initial_fileset_for_all_languages_is_red_failed
    Code_files.each do |language,filename|
      root_test_dir_reset
      kata = make_kata(language)
      avatar_name = 'hippo'
      avatar = Avatar.new(kata, avatar_name)
      visible_files = avatar.visible_files      
      output = avatar.run_tests(visible_files)
      info = avatar.name + ', ' + language
      assert_equal :failed, avatar.increments.last[:outcome], info + ', red,' + output
      print '.'      
    end    
  end    

  def test_that_altering_42_to_54_for_all_languages_is_green_passed
    Code_files.each do |language,filename|
      root_test_dir_reset
      kata = make_kata(language)
      avatar_name = 'lion'
      avatar = Avatar.new(kata, avatar_name)
      visible_files = avatar.visible_files
      test_code = visible_files[filename]
      visible_files[filename] = test_code.sub('42', '54')
      output = avatar.run_tests(visible_files)
      info = avatar.name + ', ' + language
      assert_equal :passed, avatar.increments.last[:outcome], info  + ', green,' + output
      print '.'      
    end    
  end    
      
  def test_that_altering_42_to_4typo2_for_all_languages_is_amber_error
    Code_files.each do |language,filename|
      root_test_dir_reset
      kata = make_kata(language)
      avatar_name = 'moose'
      avatar = Avatar.new(kata, avatar_name)
      visible_files = avatar.visible_files
      test_code = visible_files[filename]
      visible_files[filename] = test_code.sub('42', '4typo2')
      output = avatar.run_tests(visible_files)
      info = avatar.name + ', ' + language
      assert_equal :error, avatar.increments.last[:outcome], info  + ', amber,' + output
      print '.'      
    end    
  end
      
end
