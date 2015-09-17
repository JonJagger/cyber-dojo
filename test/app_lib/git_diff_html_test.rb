#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class GitDiffHtmlTests <  AppLibTestBase

  include GitDiff

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '748980',
    'non-empty same/added/deleted lines' +
       'stay as themselves' do

    @diff_lines =
    [
      same_line('once', 1),
      same_line('upon a', 2),
      same_line('time', 3),
      deleted_line('IN', 4),
      added_line('in', 4),
      same_line('the west', 5),
      same_line('Charles Bronson', 6),
      same_line('Jason Robarts', 7),
      same_line('', 8),
    ]

    @expected_lines =
    [
           '<same>once</same>',
           '<same>upon a</same>',
           '<same>time</same>',
        '<deleted>IN</deleted>',
          '<added>in</added>',
           '<same>the west</same>',
           '<same>Charles Bronson</same>',
           '<same>Jason Robarts</same>',
           '<same>&thinsp;</same>',
    ]

    @expected_line_numbers =
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
    ]

    assert_equal_diff_html

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '2117D9',
    'empty same/added/deleted lines become' +
       '&thinsp; to prevent empty lines collapsing in browser ' do

    @diff_lines =
    [
      same_line('', 4),
      added_line('', 5),
      deleted_line('', 6),
    ]

    @expected_lines =
    [
           '<same>&thinsp;</same>',
          '<added>&thinsp;</added>',
        '<deleted>&thinsp;</deleted>',
    ]


    @expected_line_numbers =
    [
           "<same><ln>4</ln></same>",
          "<added><ln>5</ln></added>",
        "<deleted><ln>6</ln></deleted>",
    ]

    assert_equal_diff_html

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B1C72E',
    'each diff-chunk is preceeded by section info' +
       'to allow auto-scrolling in browser' do

    @diff_lines =
    [
      same_line('aaa', 4),
      section(2),
      added_line('bbb', 5),
      deleted_line('ccc', 6),
      same_line('SSS', 7),
      same_line('SSS', 8),
      same_line('SSS', 9),
      same_line('SSS', 10),
      same_line('SSS', 11),
      same_line('SSS', 12),
      same_line('SSS', 13),
      section(3),
      added_line('ddd', 14),
      deleted_line('eee', 15),
    ]

    @expected_lines =
    [
           '<same>aaa</same>',
          "<span id='ennio_section_2'></span>",
          '<added>bbb</added>',
        '<deleted>ccc</deleted>',
           '<same>SSS</same>',
           '<same>SSS</same>',
           '<same>SSS</same>',
           '<same>SSS</same>',
           '<same>SSS</same>',
           '<same>SSS</same>',
           '<same>SSS</same>',
          "<span id='ennio_section_3'></span>",
          '<added>ddd</added>',
        '<deleted>eee</deleted>',
    ]

    @expected_line_numbers =
    [
           "<same><ln>4</ln></same>",
          "<added><ln>5</ln></added>",
        "<deleted><ln>6</ln></deleted>",
           "<same><ln>7</ln></same>",
           "<same><ln>8</ln></same>",
           "<same><ln>9</ln></same>",
           "<same><ln>10</ln></same>",
           "<same><ln>11</ln></same>",
           "<same><ln>12</ln></same>",
           "<same><ln>13</ln></same>",
          "<added><ln>14</ln></added>",
        "<deleted><ln>15</ln></deleted>",
    ]

    assert_equal_diff_html('ennio')

  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_equal_diff_html(id = 'unused')

    assert_equal @expected_lines.join,
      git_diff_html_file(id, @diff_lines)

    assert_equal @expected_line_numbers.join,
      git_diff_html_line_numbers(@diff_lines)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def same_line(line,number)
    { :line => line, :type => :same, :number => number }
  end

  def deleted_line(line,number)
    { :line => line, :type => :deleted, :number => number }
  end

  def added_line(line,number)
    { :line => line, :type => :added, :number => number }
  end

  def section(index)
    { :type => :section, :index => index }
  end

end
