#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class GitDiffHtmlTests <  CyberDojoTestBase

  include GitDiff

  test 'mixture with more than 9 lines' do
    diffed =
    [
      { :line => 'once',              :type => :same,    :number => 1 },
      { :line => 'upon a',            :type => :same,    :number => 2 },
      { :line => 'time',              :type => :same,    :number => 3 },
      { :line => 'IN',                :type => :deleted, :number => 4 },
      { :line => 'in',                :type => :added,   :number => 4 },
      { :line => 'the west',          :type => :same,    :number => 5 },
      { :line => 'Charles Bronson',   :type => :same,    :number => 6 },
      { :line => 'Jason Robarts',     :type => :same,    :number => 7 },
      { :line => 'Henry Fonda',       :type => :same,    :number => 8 },
      { :line => 'Claudia Cardinale', :type => :same,    :number => 9 },
      { :line => 'Sergio Leone',      :type => :added,   :number => 10 },
      { :line => 'Ennio Morricone',   :type => :same,    :number => 11 },
    ]
    expected =
    [
           "<same>once</same>",
           "<same>upon a</same>",
           "<same>time</same>",
        "<deleted>IN</deleted>",
          "<added>in</added>",
           "<same>the west</same>",
           "<same>Charles Bronson</same>",
           "<same>Jason Robarts</same>",
           "<same>Henry Fonda</same>",
           "<same>Claudia Cardinale</same>",
          "<added>Sergio Leone</added>",
           "<same>Ennio Morricone</same>",
    ].join
    assert_equal expected, git_diff_html_file('ennio', diffed)

    expected =
    [
           "<same><ln>1</ln></same>",
           "<same><ln>2</ln></same>",
           "<same><ln>3</ln></same>",
        "<deleted><ln>4</ln></deleted>",
          "<added><ln>4</ln></added>",
           "<same><ln>5</ln></same>",
           "<same><ln>6</ln></same>",
           "<same><ln>7</ln></same>",
           "<same><ln>8</ln></same>",
           "<same><ln>9</ln></same>",
          "<added><ln>10</ln></added>",
           "<same><ln>11</ln></same>",
    ].join
    assert_equal expected, git_diff_html_line_numbers(diffed)

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test 'some lines same some lines added some lines deleted' do
    diffed =
    [
      { :line => "once",     :type => :same,    :number => 1 },
      { :line => "upon a",   :type => :same,    :number => 2 },
      { :line => "time",     :type => :same,    :number => 3 },
      { :line => "IN",       :type => :deleted, :number => 4 },
      { :line => "in",       :type => :added,   :number => 4 },
      { :line => "the west", :type => :same,    :number => 5 },
    ]
    expected =
    [
           "<same>once</same>",
           "<same>upon a</same>",
           "<same>time</same>",
        "<deleted>IN</deleted>",
          "<added>in</added>",
           "<same>the west</same>",
    ].join
    assert_equal expected, git_diff_html_file('ennio', diffed)

    expected =
    [
           "<same><ln>1</ln></same>",
           "<same><ln>2</ln></same>",
           "<same><ln>3</ln></same>",
        "<deleted><ln>4</ln></deleted>",
          "<added><ln>4</ln></added>",
           "<same><ln>5</ln></same>",
    ].join
    assert_equal expected, git_diff_html_line_numbers(diffed)

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test 'some lines same some lines added' do
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
         "<same>once</same>",
         "<same>upon a</same>",
         "<same>time</same>",
        "<added>in</added>",
         "<same>the west</same>",
        ].join
    assert_equal expected, git_diff_html_file('ennio', diffed)

    expected =
    [
         "<same><ln>1</ln></same>",
         "<same><ln>2</ln></same>",
         "<same><ln>3</ln></same>",
        "<added><ln>4</ln></added>",
         "<same><ln>5</ln></same>",
        ].join
    assert_equal expected, git_diff_html_line_numbers(diffed)

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test 'all lines same' do
    diffed =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
    ]

    expected =
    [
        '<same>once</same>',
        '<same>upon a</same>',
        '<same>time</same>',
        '<same>in the west</same>'
    ].join
    assert_equal expected, git_diff_html_file('ennio', diffed)

    expected =
    [
        '<same><ln>1</ln></same>',
        '<same><ln>2</ln></same>',
        '<same><ln>3</ln></same>',
        '<same><ln>4</ln></same>'
    ].join
    assert_equal expected, git_diff_html_line_numbers(diffed)

  end

end
