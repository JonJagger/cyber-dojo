require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'
require 'make_time_helper.rb'
# > ruby test/functional/git_diff_view_tests.rb

class GitDiffViewTests < ActionController::TestCase

  include GitDiff
  include MakeTimeHelper
  
  def make_params(language)
    params = {
      :root_dir => RAILS_ROOT + '/test/cyberdojo',
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Jon Jagger'
    }
  end

  def make_kata(language = 'Ruby-installed-and-working') 
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end
  
  #-----------------------------------------------

  def run_tests(avatar, visible_files)
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    language = avatar.kata.language
    sandbox_dir = RAILS_ROOT + '/test/cyberdojo/sandboxes/' + temp_dir
    language_dir = RAILS_ROOT +  '/test/cyberdojo/languages/' + language        
    output = CodeRunner::run(sandbox_dir, language_dir, visible_files)
    visible_files['output'] = output
    inc = CodeOutputParser::parse(avatar.kata.unit_test_framework, output)
    inc[:time] = make_time(Time::now)
    avatar.save_run_tests(visible_files, inc)
  end


  test "building_diff_view_from_git_repo" do
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
    run_tests(avatar, visible_files)
    assert_equal :red, avatar.increments.last[:outcome]

    # create tag 2 in the repo 
    visible_files['untitled.rb'] = untitled_rb.sub('42', '54')
    run_tests(avatar, visible_files)
    assert_equal :green, avatar.increments.last[:outcome]
    
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
  
  #-----------------------------------------------

  test "sameify_with_joined_newlines" do
    
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
  
  def great_great_film 
<<HERE
once
upon a
time
in the west
HERE
  end
  
end
