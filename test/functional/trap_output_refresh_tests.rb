require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/trap_output_refresh_tests.rb

class TrapOutputRefreshTests < ActionController::TestCase

  # If you click run-tests and then so a browser refresh
  # the output is not restored correctly
  
  ROOT_TEST_DIR = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end

  def make_params(language)
    params = {
      :katas_root_dir => ROOT_TEST_DIR,
      :filesets_root_dir => RAILS_ROOT +  '/filesets',
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Valentine'
    }
  end

  def make_kata(language)
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end
  
  def test_output_is_correct_after_refresh
    language = 'C Assert'
    root_test_dir_reset
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'lion')
    output = avatar.run_tests(avatar.visible_files)
    # now refresh
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
