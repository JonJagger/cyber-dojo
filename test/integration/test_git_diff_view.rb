#!/usr/bin/env ruby

__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../cyberdojo_test_base'
require __DIR__ + '/externals'
require 'GitDiff'
require 'Dojo'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'
require 'Katas'
require 'Kata'
require 'Id'
require 'Avatars'
require 'Avatar'
require 'Sandbox'
require 'OutputParser'

class GitDiffViewTests < CyberDojoTestBase

  include Externals
  include GitDiff

  def setup
    super
    @dojo = Dojo.new(root_path,'json',externals)
  end

  class MockIdFactory
    def initialize(mock_ids)
      @n = -1
      @mock_ids = mock_ids
    end
    def create_id
      @mock_ids[@n += 1]
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "building diff view from git repo with modified file" do
    language = @dojo.languages['Ruby-installed-and-working']
    exercise = @dojo.exercises['test_Yahtzee']
    `rm -rf #{@dojo.katas.path}`
    kata = @dojo.katas.create_kata(language, exercise)
    avatar = kata.start_avatar # tag 0
    visible_files =
      {
        'cyber-dojo.sh'    => cyberdojo_sh,
        'untitled.rb'      => untitled_rb,
        'test_untitled.rb' => test_untitled_rb,
        'output'           => ''
      }
    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }
    run_test(delta, avatar, visible_files) # tag 1
    assert_equal 'red', avatar.traffic_lights.last['colour'], avatar.visible_files["output"]

    visible_files['untitled.rb'] = untitled_rb.sub('42', '54')
    delta = {
      :changed => [ 'untitled.rb' ],
      :unchanged => visible_files.keys - [ 'untitled.rb' ],
      :deleted => [ ],
      :new => [ ]
    }

    run_test(delta, avatar, visible_files) # tag 2
    assert_equal 'green', avatar.traffic_lights.last['colour']

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

    diffs = git_diff_prepare(view, MockIdFactory.new(["1","2","3"]))
    expected_diffs = [
      {
        :id => "id_1",
        :filename => "cyber-dojo.sh",
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content => "<same>ruby test_untitled.rb</same>",
        :line_numbers => "<same><ln>1</ln></same>"
      },
      {
        :id => "id_2",
        :filename => "test_untitled.rb",
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content =>
        "<same>require './untitled'</same>" +
        "<same>require 'test/unit'</same>" +
        "<same>&thinsp;</same>" +
        "<same>class TestUntitled &lt; Test::Unit::TestCase</same>" +
        "<same>&thinsp;</same>" +
        "<same>  def test_simple</same>" +
        "<same>    assert_equal 9 * 6, answer</same>" +
        "<same>  end</same>" +
        "<same>&thinsp;</same>" +
        "<same>end</same>",
        :line_numbers =>
        "<same><ln>1</ln></same>" +
        "<same><ln>2</ln></same>" +
        "<same><ln>3</ln></same>" +
        "<same><ln>4</ln></same>" +
        "<same><ln>5</ln></same>" +
        "<same><ln>6</ln></same>" +
        "<same><ln>7</ln></same>" +
        "<same><ln>8</ln></same>" +
        "<same><ln>9</ln></same>" +
        "<same><ln>10</ln></same>"
      },
      {
        :id => "id_3",
        :filename => "untitled.rb",
        :section_count => 1,
        :deleted_line_count => 1,
        :added_line_count => 1,
        :content =>
        "<same>def answer</same>" + "<span id='id_3_section_0'></span>" +
        "<deleted>  42</deleted>" +
        "<added>  54</added>" +
        "<same>end</same>",
        :line_numbers =>
        "<same><ln>1</ln></same>" +
        "<deleted><ln>2</ln></deleted>" +
        "<added><ln>2</ln></added>" +
        "<same><ln>3</ln></same>"
      }
    ]

    assert_equal expected_diffs[0], diffs[0], "0"
    assert_equal expected_diffs[1], diffs[1], "1"
    assert_equal expected_diffs[2], diffs[2], "2"
  end

  #-----------------------------------------------

  test "building git diff view from repo with deleted file" do
    language = @dojo.languages['Ruby-installed-and-working']
    exercise = @dojo.exercises['test_Yahtzee']
    `rm -rf #{@dojo.katas.path}`
    kata = @dojo.katas.create_kata(language, exercise)
    avatar = kata.start_avatar # tag 0
    visible_files =
      {
        'cyber-dojo.sh'    => cyberdojo_sh,
        'untitled.rb'      => untitled_rb,
        'test_untitled.rb' => test_untitled_rb,
        'output'           => ''
      }
    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }

    run_test(delta, avatar, visible_files) # tag 1
    assert_equal 'red', avatar.traffic_lights.last['colour'], avatar.visible_files["output"]

    visible_files.delete('untitled.rb') # will cause amber
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ 'untitled.rb' ],
      :deleted => [ 'untitled.rb' ],
      :new => [ ]
    }

    run_test(delta, avatar, visible_files) # tag 2
    assert_equal 'amber', avatar.traffic_lights.last['colour']

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

  test "only visible files are commited and are seen in diff_lines" do
    language = @dojo.languages['test-Java-JUnit']
    exercise = @dojo.exercises['test_Yahtzee']
    `rm -rf #{@dojo.katas.path}`
    kata = @dojo.katas.create_kata(language, exercise)
    avatar = kata.start_avatar # tag 0
    visible_files = avatar.visible_files

    cyber_dojo_sh = visible_files['cyber-dojo.sh']
    cyber_dojo_sh += "\n"
    cyber_dojo_sh += "echo xxx > jj.x"
    visible_files['cyber-dojo.sh'] = cyber_dojo_sh
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]
    }
    run_test(delta, avatar, visible_files) # tag 1

    from_tag = 0
    to_tag = 1
    view = git_diff_view(avatar, from_tag, to_tag)

    view.keys.each do |filename|
      assert visible_files.keys.include?(filename),
            "visible_files.keys.include?(#{filename})"
    end

    assert_equal view.length, visible_files.length
  end

  #-----------------------------------------------

  test "id_factory" do
    factory = IdFactory.new
    (1..5).each { |n|
      uuid = factory.create_id
      assert_equal 10, uuid.length
      uuid.chars { |ch|
        assert_not_nil "0123456789ABCDEF".index(ch)
      }
    }
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

  #-----------------------------------------------

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

  #-----------------------------------------------

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

  #-----------------------------------------------

  def great_great_film
<<HERE
once
upon a
time
in the west
HERE
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

end
