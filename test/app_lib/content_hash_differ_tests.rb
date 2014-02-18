require File.dirname(__FILE__) + '/../test_helper'
require 'ContentHashDiffer'

class ContentHashDifferTests < ActionController::TestCase

  test "unchanged hashes seen as unchanged" do
    incoming = { 'wibble.h' => 3424234 }
    outgoing = { 'wibble.h' => 3424234 }
    result = ContentHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.h'], result[:unchanged]
    assert_equal [ ],          result[:changed]    
    assert_equal [ ],          result[:deleted]
    assert_equal [ ],          result[:new]        
  end
  
  test "changed hashes seen as changed" do
    incoming = { 'wibble.h' => 52674 }
    outgoing = { 'wibble.h' => 3424234 }
    result = ContentHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.h'], result[:changed]
    assert_equal [ ],          result[:unchanged]    
    assert_equal [ ],          result[:deleted]
    assert_equal [ ],          result[:new]        
  end

  test "new content seen as new content and deleted content as deleted content" do
    incoming = { 'wibble.h' => 52674 }
    outgoing = { 'wibble.c' => 3424234 }
    result = ContentHashDiffer.diff(incoming, outgoing)
    assert_equal ['wibble.c'], result[:new]
    assert_equal [ ],          result[:changed]    
    assert_equal ['wibble.h'], result[:deleted]
    assert_equal [ ],          result[:unchanged]            
  end
    
  test "example 1" do
    incoming = { 'same.h' => 52674, 'changed.c' => 3424234, 'deleted.h' => -234 }
    outgoing = { 'same.h' => 52674, 'changed.c' => 46532, 'added.txt' => -345345 }
    result = ContentHashDiffer.diff(incoming, outgoing)
    assert_equal ['same.h'],    result[:unchanged]
    assert_equal ['changed.c'], result[:changed]    
    assert_equal ['deleted.h'], result[:deleted]
    assert_equal ['added.txt'], result[:new]    
  end

end

