require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/trap_output_refresh_tests.rb

class TrapOutputRefreshTests < ActionController::TestCase

  # If you click run-tests and then so a browser refresh
  # the output is not restored correctly
  
  Root_test_folder = RAILS_ROOT + '/test/test_katas'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params(language)
    { :kata_name => language, 
      :kata_root => Root_test_folder,
      :filesets_root => RAILS_ROOT + '/filesets',
      'language' => language,
      'exercise' => 'Prime Factors'
    }
  end

  Code_files = { 
    'C' => 'untitled.c',
  }
  
  def test_output_is_correct_after_refresh
    language = 'C'
    root_test_folder_reset
    params = make_params(language)
    assert Kata::create(params)
    assert Kata::configure(params)
    kata = Kata.new(params)
    avatar = Avatar.new(kata, 'lion')
    output = avatar.run_tests(avatar.visible_files)
    # now refresh
    kata = Kata.new(params)
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
