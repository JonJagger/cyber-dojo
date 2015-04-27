#!/usr/bin/env ../test_wrapper.sh app/models

require_relative 'model_test_base'

class TagsTest < ModelTestBase

  def setup
    super
    set_runner_class_name('DummyTestRunner')    
  end

  test 'tag zero exists after avatar is started ' +
       'and before first [test] is run ' +
       'and contains all visible files' do
    kata = make_kata
    avatar = kata.start_avatar
    tags = avatar.tags
    assert_equal 1, tags.length
    n = 0
    tags.each { n += 1 }
    assert_equal 1, n
    visible_files = tags[0].visible_files
    filenames = ['hiker.h', 'hiker.c', 'instructions','cyber-dojo.sh','makefile','output']
    filenames.each { |filename| assert visible_files.keys.include?(filename), filename }
    assert_equal '', tags[0].output
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'each [test]-event creates a new tag' do
    set_runner_class_name('StubTestRunner')            
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    stub_test(lion, test_count=3)
    tags = lion.tags
    assert_equal test_count+1, tags.length
    (0..tags.length).each { |i| assert_equal i, tags[i].number }
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'tags[-n] duplicates Array[-n] behaviour' do
    set_runner_class_name('StubTestRunner')            
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    stub_test(lion, test_count=3)
    tags = lion.tags
    (1..tags.length).each {|i| assert_equal tags.length-i, tags[-i].number }
  end
    
end
