require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

class GitDiffViewTests < ActionController::TestCase

  include GitDiff
  
  test "building diff view from git repo with modified file" do
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

    visible_files['untitled.rb'] = untitled_rb.sub('42', '54')
    
    # create tag 2 in the repo     
    run_tests(avatar, visible_files)
    assert_equal :green, avatar.increments.last[:colour]
    
    was_tag = 1
    now_tag = 2    
    view = git_diff_view(avatar, was_tag, now_tag)
    view.delete('output')
    
    expected =
    {
      'untitled.rb' =>
      [
        { :line => "def answer", :type => :same,    :number => 1 },
        { :type => :section, :index => 0 },        
        { :line => "  42",       :type => :deleted, :number => 2 },
        { :line => "  54",       :type => :added,   :number => 2 },
        { :line => "end",        :type => :same,    :number => 3 },
      ],
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyber-dojo.sh' => sameify(cyberdojo_sh)
    }
    
    assert_equal expected, view
    
    
    class MockUuidFactory
      
      def initialize(mock_uuids)
        @n = -1
        @mock_uuids = mock_uuids
      end
      
      def create_uuid
        @mock_uuids[@n += 1]
      end
      
    end
    
    diffs = git_diff_prepare(avatar, view, MockUuidFactory.new(["1","2","3"]))
    expected_diffs = [
      {
        :id => "id_1",
        :name => "cyber-dojo.sh",
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content => "<same><ln>  1</ln>ruby test_untitled.rb</same>"
      },
      {
        :id => "id_2",
        :name => "test_untitled.rb",
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content =>
        "<same><ln>  1</ln>require './untitled'</same>" +
        "<same><ln>  2</ln>require 'test/unit'</same>" +
        "<same><ln>  3</ln></same>" +
        "<same><ln>  4</ln>class TestUntitled &lt; Test::Unit::TestCase</same>" +
        "<same><ln>  5</ln></same>" + 
        "<same><ln>  6</ln>  def test_simple</same>" +
        "<same><ln>  7</ln>    assert_equal 9 * 6, answer</same>" +
        "<same><ln>  8</ln>  end</same>" +
        "<same><ln>  9</ln></same>" +
        "<same><ln> 10</ln>end</same>"
      },
      {
        :id => "id_3",
        :name => "untitled.rb",
        :section_count => 1,
        :deleted_line_count => 1,
        :added_line_count => 1,
        :content =>
        "<same><ln>  1</ln>def answer</same><span id='id_3_section_0'></span>" +
        "<deleted><ln>  2</ln>  42</deleted><added><ln>  2</ln>  54</added>" +
        "<same><ln>  3</ln>end</same>"
      }
    ]

    assert_equal expected_diffs, diffs

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

    visible_files.delete('untitled.rb')
    
    # create tag 2 in the repo 
    run_tests(avatar, visible_files)
    assert_equal :amber, avatar.increments.last[:colour]
    
    from_tag = 1
    to_tag = 2    
    view = git_diff_view(avatar, from_tag, to_tag)
    view.delete('output')

    expected =
    {
      'untitled.rb'      => deleteify(LineSplitter.line_split(untitled_rb)),
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyber-dojo.sh'    => sameify(cyberdojo_sh)
    }
    
    assert_equal expected, view
  end

  #-----------------------------------------------

  test "uuid_factory" do
    factory = UuidFactory.new
    (1..5).each { |n|
      uuid = factory.create_uuid
      assert_equal 10, uuid.length
      uuid.chars { |ch|
        assert_not_nil "0123456789ABCDEF".index(ch)
      }
    }
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
    assert_equal expected, deleteify(LineSplitter.line_split(great_great_film))
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
