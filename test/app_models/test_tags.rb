#!/usr/bin/env ruby

require_relative 'model_test_base'

class TagsTest < ModelTestBase

  test 'tag zero exists after avatar is started ' +
       'and before first [test] is run' do
    kata = make_kata
    avatar = kata.start_avatar
    tags = avatar.tags
    assert_equal 1, tags.length
    n = 0
    tags.each { n += 1 }
    assert_equal 1, n
    # starting an avatar causes commit tag=0 with initial visible files.
    visible_files = tags[0].visible_files
    ['hiker.h', 'hiker.c', 'instructions','cyber-dojo.sh','makefile','output'].each do |filename|
      assert visible_files.keys.include?(filename), filename
    end
    assert_equal '', tags[0].output
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'each [test]-event creates a new tag' do
    set_runner_class_name('StubTestRunner')            
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    stub_test(lion, [:red,:amber,:green])
    tags = lion.tags
    assert_equal 4, tags.length
    assert tags.all?{|tag| tag.class.name === 'Tag'}
    n = 2
    visible_files = tags[n].visible_files
    #p visible_files.inspect
    #assert_equal [f1,f2,f3], visible_files.keys.sort
    #assert_equal f1_content, visible_files[f1]
    #assert_equal f2_content, visible_files[f2]
  end

  #- - - - - - - - - - - - - - - - - - -

=begin
  test 'tags[-1] is the last tag' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    fake_three_tests(lion)
    assert_equal 4, lion.tags.length
    manifest = JSON.unparse({
      f1='Hiker.cs' => f1_content='public class Hiker { }',
      f2='HikerTest.cs' => f2_content='using NUnit.Framework;',
      f3='output' => 'Tests run: 1, Failures: 0'
    })
    n = 3
    filename = 'manifest.json'
    git.spy(lion.dir.path,'show',"#{n}:#{filename}",manifest)

    visible_files = lion.tags[-1].visible_files
    assert_equal [f1,f2,f3], visible_files.keys.sort
    assert_equal f1_content, visible_files[f1]
    assert_equal f2_content, visible_files[f2]    
  end
=end
  
end
