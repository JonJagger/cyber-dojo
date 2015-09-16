#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class ReviewFilePickerTests < AppLibTestBase

  include ReviewFilePicker

  def setup
    super
    @n = -1
  end

  #------------------------------------------------------------------

  test 'when current_filename has diffs it is chosen '+
       'even if another file has more changed lines' do
    @current_filename = 'def'
    @diffs = [ ] <<
      diff('abc',22,32) <<
      (@picked=diff(@current_filename,3,1))
    assert_picked
  end

  #------------------------------------------------------------------

  test '9EF3C0',
    'when current_filename has diffs it is chosen if' +
       'another file has equal number of diffs' do
    @current_filename = 'hiker.h'
    @diffs = [ ] <<
      diff('cyber-dojo.sh',0,0) <<
      diff('hiker.c',1,1) <<
      (@picked=diff(@current_filename,1,1)) <<
      diff('hiker.tests.c',0,0)
    assert_picked
  end

  #------------------------------------------------------------------

  test '6E524A',
    'when current_filename has no diffs it is chosen if' +
       'it is still exists and no other file has any diffs' do
    @current_filename = 'wibble.cs'
    @diffs = [ ] <<
      diff('abc',0,0) <<
      (@picked=diff(@current_filename,0,0))
    assert_picked
  end

  #------------------------------------------------------------------

  test 'E45291',
    'when current_filename has no diffs it is still chosen if' +
       'only other file with diffs is output' do
    @current_filename = 'fubar.cpp'
    @diffs = [ ] <<
      diff('output',2,4) <<
      (@picked=diff(@current_filename,0,0))
    assert_picked
  end

  #------------------------------------------------------------------

  test '84253F',
    'when current_filename has no diffs and another non-output file' +
       'has diffs the current_filename is not chosen' do
    @current_filename = 'def'
    @diffs = [ ] <<
      (@picked=diff('not-output',2,4)) <<
      diff(@current_filename,0,0)
    assert_picked
  end

  #------------------------------------------------------------------

  test '80A6FB',
    'when current_filename is not present and a non output file' +
       'has diffs then the one with the most diffs is chosen' do
    @current_filename = 'not-present'
    @diffs = [ ] <<
      diff('output',9,8) <<
      diff('wibble.h',2,4) <<
      diff('wibble.c',0,0) <<
      (@picked=diff('instructions',3,4))
    assert_picked
  end

  #------------------------------------------------------------------

  test '8D0729',
    'when current_filename is not present and no non-output file' +
       'has diffs then largest code file is chosen' do
    @current_filename = nil
    non_code_filenames = [ 'instructions','makefile','cyber-dojo.sh' ]
    non_code_filenames.each do |filename|
      @diffs = [ ] <<
        diff('output',6,8,'13453453534535345345') <<
        diff(filename,0,0,'bigger-but-not-codefile') <<
        (@picked=diff('wibble.c',0,0,'smaller'))
      assert_picked
    end
  end

  #------------------------------------------------------------------

  test '7E59A3',
    'when current_filename is not present and no non-output file' +
       'has diffs and no code files then pick cyber-dojo.sh' do
    @current_filename = nil
    @diffs = [ ] <<
      diff('output',6,8,'13453453534535345345') <<
      (@picked = diff('cyber-dojo.sh',0,0,'145345'))
    assert_picked
  end
  
  #------------------------------------------------------------------

  def diff(filename,dc,ac,content='')
    @n += 1
    {
      :filename => filename,
      :deleted_line_count => dc,
      :added_line_count => ac,
      :id => 'id_' + @n.to_s,
      :content => content
    }
  end

  def assert_picked
    id = pick_file_id(@diffs, @current_filename)
    assert_equal @picked[:id], id
  end

end
