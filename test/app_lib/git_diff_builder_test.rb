#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class GitDiffBuilderTests < AppLibTestBase

  test 'A332D7',
  'chunk with a space in its filename' do

    @diff_lines =
    [
      'diff --git a/sandbox/file with_space b/sandbox/file with_space',
      'new file mode 100644',
      'index 0000000..21984c7',
      '--- /dev/null',
      '+++ b/sandbox/file with_space',
      '@@ -0,0 +1 @@',
      '+Please rename me!',
      '\\ No newline at end of file'
    ]

    @source_lines =
    [
      'Please rename me!'
    ]

    @expected =
    [
      section(0),
      added_line('Please rename me!', 1),
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '45733C',
  'chunk with defaulted now line info' do

    @diff_lines =
    [
      'diff --git a/sandbox/untitled_5G3 b/sandbox/untitled_5G3',
      'index e69de29..2e65efe 100644',
      '--- a/sandbox/untitled_5G3',
      '+++ b/sandbox/untitled_5G3',
      '@@ -0,0 +1 @@',
      '+aaa',
      '\\ No newline at end of file'
    ]

    @source_lines =
    [
      'aaa'
    ]

    @expected =
    [
      section(0),
      added_line('aaa', 1),
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'D19F10',
    'two chunks with leading and trailing same lines' +
       'and no newline at eof' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index b1a30d9..7fa9727 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,5 +1,5 @@',
      ' aaa',
      '-bbb',
      '+ccc',
      ' ddd',
      ' eee',
      ' fff',
      '@@ -8,6 +8,6 @@',
      ' nnn',
      ' ooo',
      ' ppp',
      '-qqq',
      '+rrr',
      ' sss',
      ' ttt',
      '\\ No newline at end of file'
    ]

    @source_lines =
    [
      'aaa',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'ggg',
      'hhh',
      'nnn',
      'ooo',
      'ppp',
      'rrr',
      'sss',
      'ttt'
    ]

    @expected =
    [
      same_line('aaa', 1),
      section(0),
      deleted_line('bbb', 2),
      added_line('ccc', 2),
      same_line('ddd',  3),
      same_line('eee',  4),
      same_line('fff',  5),
      same_line('ggg',  6),
      same_line('hhh',  7),
      same_line('nnn',  8),
      same_line('ooo',  9),
      same_line('ppp', 10),
      section(1),
      deleted_line('qqq', 11),
      added_line('rrr', 11),
      same_line('sss', 12),
      same_line('ttt', 13)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '2191C8',
    'diffs 7 lines apart are not merged' +
       'into contiguous sections in one chunk' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 0719398..2943489 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,4 +1,4 @@',
      '-aaa',
      '+bbb',
      ' ccc',
      ' ddd',
      ' eee',
      '@@ -6,4 +6,4 @@',
      ' ppp',
      ' qqq',
      ' rrr',
      '-sss',
      '+ttt'
    ]

    @source_lines =
    [
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'ppp',
      'qqq',
      'rrr',
      'ttt'
    ]

    @expected =
    [
      section(0),
      deleted_line('aaa', 1),
      added_line('bbb', 1),
      same_line('ccc', 2),
      same_line('ddd', 3),
      same_line('eee', 4),
      same_line('fff', 5),
      same_line('ppp', 6),
      same_line('qqq', 7),
      same_line('rrr', 8),
      section(1),
      deleted_line('sss', 9),
      added_line('ttt', 9)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '3F8C58',
    'one chunk with two sections' +
       'each with one line added and one line deleted' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 535d2b0..a173ef1 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,8 +1,8 @@',
      ' aaa',
      ' bbb',
      '-ccc',
      '+ddd',
      ' eee',
      '-fff',
      '+ggg',
      ' hhh',
      ' iii',
      ' jjj'
    ]

    @source_lines =
    [
      'aaa',
      'bbb',
      'ddd',
      'eee',
      'ggg',
      'hhh',
      'iii',
      'jjj'
    ]

    @expected =
    [
      same_line('aaa', 1),
      same_line('bbb', 2),
      section(0),
      deleted_line('ccc', 3),
      added_line('ddd', 3),
      same_line('eee', 4),
      section(1),
      deleted_line('fff', 5),
      added_line('ggg', 5),
      same_line('hhh', 6),
      same_line('iii', 7),
      same_line('jjj', 8)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '50C56A',
  'one chunk with one section with only lines added' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 06e567b..59e88aa 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,6 +1,9 @@',
      ' aaa',
      ' bbb',
      ' ccc',
      '+ddd',
      '+eee',
      '+fff',
      ' ggg',
      ' hhh',
      ' iii'
    ]

    @source_lines =
    [
      'aaa',
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'ggg',
      'hhh',
      'iii',
      'jjj'
    ]

    @expected =
    [
      same_line('aaa', 1),
      same_line('bbb', 2),
      same_line('ccc', 3),
      section(0),
      added_line('ddd', 4),
      added_line('eee', 5),
      added_line('fff', 6),
      same_line('ggg', 7),
      same_line('hhh', 8),
      same_line('iii', 9),
      same_line('jjj', 10)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '386FA0',
  'one chunk with one section with only lines deleted' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 0b669b6..a972632 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -2,8 +2,6 @@',
      ' bbb',
      ' ccc',
      ' ddd',
      '-EEE',
      '-FFF',
      ' ggg',
      ' hhh',
      ' iii'
    ]

    @source_lines =
    [
      'aaa',
      'bbb',
      'ccc',
      'ddd',
      'ggg',
      'hhh',
      'iii',
      'jjj'
    ]

    @expected =
    [
      same_line('aaa', 1),
      same_line('bbb', 2),
      same_line('ccc', 3),
      same_line('ddd', 4),
      section(0),
      deleted_line('EEE', 5),
      deleted_line('FFF', 6),
      same_line('ggg', 5),
      same_line('hhh', 6),
      same_line('iii', 7),
      same_line('jjj', 8)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '970ED0',
    'one chunk with one section' +
       'with more lines deleted than added' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 08fe19c..1f8695e 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -3,9 +3,7 @@',
      ' ddd',
      ' eee',
      ' fff',
      '-ggg',
      '-hhh',
      '-iii',
      '+jjj',
      ' kkk',
      ' lll',
      ' mmm'
    ]

    @source_lines =
    [
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'fff',
      'jjj',
      'kkk',
      'lll',
      'mmm',
      'nnn'
    ]

    @expected =
    [
      same_line('bbb', 1),
      same_line('ccc', 2),
      same_line('ddd', 3),
      same_line('eee', 4),
      same_line('fff', 5),
      section(0),
      deleted_line('ggg', 6),
      deleted_line('hhh', 7),
      deleted_line('iii', 8),
      added_line('jjj', 6),
      same_line('kkk', 7),
      same_line('lll', 8),
      same_line('mmm', 9),
      same_line('nnn', 10)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '56BCAD',
    'one chunk with one section' +
       'with more lines added than deleted' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 8e435da..a787223 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -3,7 +3,8 @@',
      ' ccc',
      ' ddd',
      ' eee',
      '-fff',
      '+XXX',
      '+YYY',
      ' ggg',
      ' hhh',
      ' iii'
    ]

    @source_lines =
    [
      'aaa',
      'bbb',
      'ccc',
      'ddd',
      'eee',
      'XXX',
      'YYY',
      'ggg',
      'hhh',
      'iii',
      'jjj',
      'kkk',
      'lll',
      'mmm'
    ]

    @expected =
    [
      same_line('aaa', 1),
      same_line('bbb', 2),
      same_line('ccc', 3),
      same_line('ddd', 4),
      same_line('eee', 5),
      section(0),
      deleted_line('fff', 6),
      added_line('XXX',6),
      added_line('YYY',7),
      same_line('ggg',   8),
      same_line('hhh',   9),
      same_line('iii',  10),
      same_line('jjj', 11),
      same_line('kkk', 12),
      same_line('lll', 13),
      same_line('mmm',14),
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'A42951',
    'one chunk with one section' +
       'with one line deleted and one line added' do

    @diff_lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 5ed4618..aad3f67 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -5,7 +5,7 @@',
      ' aaa',
      ' bbb',
      ' ccc',
      '-QQQ',
      '+RRR',
      ' ddd',
      ' eee',
      ' fff'
    ]

    @source_lines =
    [
      'zz',
      'yy',
      'xx',
      'ww',
      'aaa',
      'bbb',
      'ccc',
      'RRR',
      'ddd',
      'eee',
      'fff',
      'ggg',
      'hhh'
    ]

    @expected =
    [
      same_line('zz', 1),
      same_line('yy', 2),
      same_line('xx', 3),
      same_line('ww', 4),
      same_line('aaa', 5),
      same_line('bbb', 6),
      same_line('ccc', 7),
      section(0),
      deleted_line('QQQ', 8),
      added_line('RRR', 8),
      same_line('ddd',   9),
      same_line('eee', 10),
      same_line('fff', 11),
      same_line('ggg', 12),
      same_line('hhh', 13)
    ]

    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_equal_builder
    diff = GitDiff::GitDiffParser.new(@diff_lines.join("\n")).parse_one
    builder = GitDiff::GitDiffBuilder.new()
    actual = builder.build(diff, @source_lines)
    assert_equal @expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

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
