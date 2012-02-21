require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

# > ruby test/functional/installation_tests.rb

class InstallationTests < ActionController::TestCase

  include Folders

  def test_actual_installed_languages
    result = check_languages(RAILS_ROOT + '/filesets')
    installed_and_working = result[0]
    cannot_check_because_no_42_file = result[1]
    not_installed = result[2]
    installed_but_not_working = result[3]
    
    assert_equal [ ], cannot_check_because_no_42_file
    assert_equal [ ], installed_but_not_working
  end

  def test_installed_languages_testing_mechanism
    result = check_languages(RAILS_ROOT + '/test/functional')
    installed_and_working = result[0]
    cannot_check_because_no_42_file = result[1]
    not_installed = result[2]
    installed_but_not_working = result[3]
    
    assert_equal ['Ruby-installed-and-working'], installed_and_working
    assert_equal ['Ruby-no-42-files'], cannot_check_because_no_42_file
    assert_equal ['Ruby-not-installed'], not_installed
    assert_equal ['Ruby-installed-but-not-working'], installed_but_not_working
  end

  def check_languages(filesets_root_dir)
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
        
    languages_root_dir = filesets_root_dir + '/language'
    languages = folders_in(languages_root_dir).sort
    languages.each do |language|
      language_dir = languages_root_dir + '/' + language
      manifest = eval IO.read(language_dir + '/manifest.rb')
      visible_files = manifest[:visible_filenames]
      filenames = visible_files.select do |visible_filename|
        IO.read(language_dir + '/' + visible_filename).include? '42'
      end
      if filenames == [ ]
        cannot_check_because_no_42_file << language
      else
        filename = filenames[0]
        rag = red_amber_green(filesets_root_dir,language,filename)
        if rag == [:failed,:error,:passed]
          installed_and_working << language
        elsif rag == [:error, :error, :error]
          not_installed << language
        else
          installed_but_not_working << language
        end
      end
    end
    [
      installed_and_working,
      cannot_check_because_no_42_file,
      not_installed,
      installed_but_not_working
    ]
  end
  
  def red_amber_green( filesets_root_dir, language, filename )
    [
      language_test(filesets_root_dir, language, filename, '42'),
      language_test(filesets_root_dir, language, filename, '4typo2'),
      language_test(filesets_root_dir, language, filename, '54')
    ]
  end
  
  def language_test( filesets_root_dir, language, filename , rhs )
    root_test_dir_reset
    kata = make_kata(filesets_root_dir, language)
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    visible_files = avatar.visible_files
    test_code = visible_files[filename]    
    visible_files[filename] = test_code.sub('42', rhs)
    avatar.run_tests(visible_files)
    avatar.increments.last[:outcome]
  end    

  def make_kata(filesets_root_dir, language)
    params = make_params(filesets_root_dir, language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end

  def make_params(filesets_root_dir, language)
    params = {
      :katas_root_dir => KATA_ROOT_DIR,
      :filesets_root_dir => filesets_root_dir,
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Jon Jagger'
    }
  end

  def root_test_dir_reset
    system("rm -rf #{KATA_ROOT_DIR}")
    Dir.mkdir KATA_ROOT_DIR
  end
  
  #FILESET_ROOT_DIR = RAILS_ROOT + '/filesets'
  KATA_ROOT_DIR = RAILS_ROOT + '/test/katas'

end
