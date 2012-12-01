require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

class GitDiffViewTests < ActionController::TestCase

  include GitDiff
  
  test "building diff view from git repo" do
    kata = make_kata('Ruby-installed-and-working')
    avatar = Avatar.new(kata, 'wolf')    
    # that will have created tag 0 in the repo

    visible_files =
      {
        'cyber-dojo.sh'    => cyberdojo_sh,
        'untitled.rb'      => untitled_rb,
        'test_untitled.rb' => test_untitled_rb,
        'output'           => '' 
      }

    # create tag 1 in the repo
    run_tests(avatar, visible_files)
    assert_equal :red, avatar.increments.last[:colour], avatar.visible_files["output"]

    # create tag 2 in the repo 
    visible_files['untitled.rb'] = untitled_rb.sub('42', '54')
    run_tests(avatar, visible_files)
    assert_equal :green, avatar.increments.last[:colour]
    
    from_tag = 1
    to_tag = 2    
    view = git_diff_view(avatar, from_tag, to_tag)
    view.delete('output')
    
    expected =
    {
      'untitled.rb' =>
      [
        { :line => "def answer", :type => :same,  :number => 1 },
        { :type => :section, :index => 0 },        
        { :line => "  42",       :type => :deleted, :number => 2 },
        { :line => "  54",       :type => :added, :number => 2 },
        { :line => "end",        :type => :same,  :number => 3 },
      ],
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyber-dojo.sh' => sameify(cyberdojo_sh)
    }
    
    assert_equal expected, view
    
  end

  #-----------------------------------------------

  test "building git diff view from repo with deleted file" do
    kata = make_kata('Ruby-installed-and-working')
    avatar = Avatar.new(kata, 'wolf')    
    # that will have created tag 0 in the repo

    visible_files =
      {
        'cyber-dojo.sh'    => cyberdojo_sh,
        'untitled.rb'      => untitled_rb,
        'test_untitled.rb' => test_untitled_rb,
        'output'           => '' 
      }

    # create tag 1 in the repo
    run_tests(avatar, visible_files)
    assert_equal :red, avatar.increments.last[:colour], avatar.visible_files["output"]

    # create tag 2 in the repo 
    visible_files.delete('untitled.rb')
    run_tests(avatar, visible_files)
    assert_equal :amber, avatar.increments.last[:colour]
    
    from_tag = 1
    to_tag = 2    
    view = git_diff_view(avatar, from_tag, to_tag)
    view.delete('output')

    expected =
    {
      'untitled.rb'      => deleteify(line_split(untitled_rb)),
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyber-dojo.sh'    => sameify(cyberdojo_sh)
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
require './untitled'
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
  
  #-----------------------------------------------

  test "sameify with joined newlines" do
    
    expected =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
      { :line => "",            :type => :same, :number => 5 },
      { :line => "",            :type => :same, :number => 6 },
    ]
    assert_equal expected, sameify(great_great_film + "\n\n")
    
  end
  
  test "sameify" do
    expected =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
    ]
    assert_equal expected, sameify(great_great_film)
  end
  
  test "deleteify" do
    expected =
    [
      { :line => "once",        :type => :deleted, :number => 1 },
      { :line => "upon a",      :type => :deleted, :number => 2 },
      { :line => "time",        :type => :deleted, :number => 3 },
      { :line => "in the west", :type => :deleted, :number => 4 },
    ]
    assert_equal expected, deleteify(line_split(great_great_film))
  end


  def great_great_film 
<<HERE
once
upon a
time
in the west
HERE
  end
  
end
