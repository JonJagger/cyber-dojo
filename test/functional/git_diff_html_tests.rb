require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/git_diff_html_tests.rb

class GitDiffHtmlTests < ActionController::TestCase

  def test_mixture_with_more_than_9_lines
    diffed =
    [
      { :line => "once",              :type => :same,    :number => 1 },
      { :line => "upon a",            :type => :same,    :number => 2 },
      { :line => "time",              :type => :same,    :number => 3 },
      { :line => "IN",                :type => :deleted               },
      { :line => "in",                :type => :added,   :number => 4 },
      { :line => "the west",          :type => :same,    :number => 5 },
      { :line => "Charles Bronson",   :type => :same,    :number => 6 },
      { :line => "Jason Robarts",     :type => :same,    :number => 7 },
      { :line => "Henry Fonda",       :type => :same,    :number => 8 },
      { :line => "Claudia Cardinale", :type => :same,    :number => 9 },
      { :line => "Sergio Leone",      :type => :added,   :number => 10 },
      { :line => "Ennio Morricone",   :type => :same,    :number => 11 },
    ]    
    expected =
    [ 
        "<ln> 1</ln><same>once</same>",
        "<ln> 2</ln><same>upon a</same>",
        "<ln> 3</ln><same>time</same>",
        "<ln>  </ln><deleted>IN</deleted>",
        "<ln> 4</ln><added>in</added>",
        "<ln> 5</ln><same>the west</same>",
        "<ln> 6</ln><same>Charles Bronson</same>",
        "<ln> 7</ln><same>Jason Robarts</same>",
        "<ln> 8</ln><same>Henry Fonda</same>",
        "<ln> 9</ln><same>Claudia Cardinale</same>",
        "<ln>10</ln><added>Sergio Leone</added>",
        "<ln>11</ln><same>Ennio Morricone</same>",        
    ].join('')
    
    assert_equal expected, git_diff_html(diffed)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - -
  
  def test_some_lines_same_some_lines_added_some_lines_deleted
    diffed =
    [
      { :line => "once",     :type => :same,    :number => 1 },
      { :line => "upon a",   :type => :same,    :number => 2 },
      { :line => "time",     :type => :same,    :number => 3 },
      { :line => "IN",       :type => :deleted               },
      { :line => "in",       :type => :added,   :number => 4 },
      { :line => "the west", :type => :same,    :number => 5 },
    ]    
    expected =
    [ 
        "<ln>1</ln><same>once</same>",
        "<ln>2</ln><same>upon a</same>",
        "<ln>3</ln><same>time</same>",
        "<ln> </ln><deleted>IN</deleted>",
        "<ln>4</ln><added>in</added>",
        "<ln>5</ln><same>the west</same>",
    ].join('')
    
    assert_equal expected, git_diff_html(diffed)
  end  
  
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def test_some_lines_same_some_lines_added
    diffed =
    [
      { :line => "once",     :type => :same, :number => 1 },
      { :line => "upon a",   :type => :same, :number => 2 },
      { :line => "time",     :type => :same, :number => 3 },
      { :line => "in",       :type => :added,:number => 4 },
      { :line => "the west", :type => :same, :number => 5 },
    ]    
    expected =
    [ 
        "<ln>1</ln><same>once</same>",
        "<ln>2</ln><same>upon a</same>",
        "<ln>3</ln><same>time</same>",
        "<ln>4</ln><added>in</added>",
        "<ln>5</ln><same>the west</same>",
    ].join('')
    
    assert_equal expected, git_diff_html(diffed)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  
  def test_all_lines_same
    diffed =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
    ]
    
    expected =
    [ 
        "<ln>1</ln><same>once</same>",
        "<ln>2</ln><same>upon a</same>",
        "<ln>3</ln><same>time</same>",
        "<ln>4</ln><same>in the west</same>"
    ].join('')
    
    assert_equal expected, git_diff_html(diffed)
  end
    
end
