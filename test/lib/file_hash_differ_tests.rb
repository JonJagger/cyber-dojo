require File.dirname(__FILE__) + '/../test_helper'
require 'file_hash_differ'

class FileHashDifferTests < ActionController::TestCase

  test "unchanged hashes seen as unchanged files" do
    incoming = { 'wibble.h' => 3424234 }
    outgoing = { 'wibble.h' => 3424234 }
    filenames = FileHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.h'], filenames[:unchanged]
    assert_equal [ ],          filenames[:changed]    
    assert_equal [ ],          filenames[:deleted]
    assert_equal [ ],          filenames[:new]        
  end
  
  test "changed hashes seen as changed files" do
    incoming = { 'wibble.h' => 52674 }
    outgoing = { 'wibble.h' => 3424234 }
    filenames = FileHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.h'], filenames[:changed]
    assert_equal [ ],          filenames[:unchanged]    
    assert_equal [ ],          filenames[:deleted]
    assert_equal [ ],          filenames[:new]        
  end

  test "new files seen as new files and deleted files as deleted files" do
    incoming = { 'wibble.h' => 52674 }
    outgoing = { 'wibble.c' => 3424234 }
    filenames = FileHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.c'], filenames[:new]
    assert_equal [ ],          filenames[:changed]    
    assert_equal ['wibble.h'], filenames[:deleted]
    assert_equal [ ],          filenames[:unchanged]            
  end
    
  test "example 1" do
    incoming = { 'same.h' => 52674, 'changed.c' => 3424234, 'deleted.h' => -234 }
    outgoing = { 'same.h' => 52674, 'changed.c' => 46532, 'added.txt' => -345345 }
    filenames = FileHashDiffer.diff(incoming, outgoing)
    assert_equal ['same.h'],    filenames[:unchanged]
    assert_equal ['changed.c'], filenames[:changed]    
    assert_equal ['deleted.h'], filenames[:deleted]
    assert_equal ['added.txt'], filenames[:new]    
  end

end

