require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

# > ruby test/functional/git_diff_view_tests.rb

class GitDiffViewTests < ActionController::TestCase

  include GitDiff
  
  ROOT_TEST_DIR = RAILS_ROOT + '/test/katas'
  KATA_NAME = 'Jon Jagger'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end

  def make_params
    { :kata_name => KATA_NAME, 
      :kata_root => ROOT_TEST_DIR,
      :filesets_root => RAILS_ROOT + '/filesets',
      'exercise' => 'Unsplice',
      'language' => 'Ruby'
    }
  end

  def make_kata
    params = make_params
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
    info = Kata::create_new(fileset, params)
    params[:kata_name] = info[:uuid]
    Kata.new(params)    
  end
  
  #-----------------------------------------------

  def test_building_diff_view_from_git_repo    
    root_test_dir_reset
    kata = make_kata
    avatar = Avatar.new(kata, 'wolf')    
    # that will have created tag 0 in the repo

    visible_files =
      {
        'cyberdojo.sh'     => cyberdojo_sh,
        'untitled.rb'      => untitled_rb,
        'test_untitled.rb' => test_untitled_rb,
        'output'           => '' 
      }

    # create tag 1 in the repo
    avatar.run_tests(visible_files)
    assert_equal :failed, avatar.increments.last[:outcome]

    # create tag 2 in the repo 
    visible_files['untitled.rb'] = untitled_rb.sub('42', '54')
    avatar.run_tests(visible_files)
    assert_equal :passed, avatar.increments.last[:outcome]
    
    tag = 2    
    view = git_diff_view(avatar, tag)
    view.delete('output')
    
    expected =
    {
      'untitled.rb' =>
      [
        { :line => "def answer", :type => :same,  :number => 1 },
        { :line => "  42",       :type => :deleted             },
        { :line => "  54",       :type => :added, :number => 2 },
        { :line => "end",        :type => :same,  :number => 3 },
      ],
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyberdojo.sh' => sameify(cyberdojo_sh)
    }
    
    assert_equal expected, view
    
  end

  #-----------------------------------------------

  def cyberdojo_sh
<<HERE
ruby test_untitled.rb
HERE
  end
  
  #-----------------------------------------------
  
  def test_untitled_rb 
<<HERE
require 'untitled'
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_simple
    assert_equal 9 * 6, answer
  end

end
HERE
  end

  #-----------------------------------------------
  
  def untitled_rb
<<HERE
def answer
  42
end
HERE
  end  
  
end
