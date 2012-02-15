require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/trap_output_refresh_tests.rb

class TrapOutputRefreshTests < ActionController::TestCase

  # If you click run-tests and then so a browser refresh
  # the output is not restored correctly
  
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
      'exercise' => 'Prime Factors'
    }
  end

  def make_kata(language)
    params = make_params(language)
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
    info = Kata::create_new(fileset, params)
    params[:id] = info[:id]
    Kata.new(params)    
  end

  Code_files = { 
    'C' => 'untitled.c',
  }
  
  def test_output_is_correct_after_refresh
    language = 'C'
    root_test_dir_reset
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'lion')
    output = avatar.run_tests(avatar.visible_files)
    # now refresh
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
