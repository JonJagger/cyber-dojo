#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'
require_relative 'DeltaMaker'

class TagsTest < AppModelTestBase

  test 'A30AF3',
    'tag zero exists after avatar is started' +
       'and before first [test] is run ' +
       'and contains all visible files' do
    language = languages['C-assert']
    exercise = exercises['Fizz_Buzz']
    kata = make_kata(unique_id, language.name, exercise.name)
    avatar = kata.start_avatar
    tags = avatar.tags
    assert_equal 1, tags.length
    n = 0
    tags.each { n += 1 }
    assert_equal 1, n
    
    stub_manifest = {
      'output' => '',
      'instructions' => exercise.instructions
    }
    language.visible_files.each do |filename,content| 
      stub_manifest[filename] = content
    end        
    git.spy(avatar.path, 'show', '0:manifest.json', JSON.unparse(stub_manifest))
    
    visible_files = tags[0].visible_files
    filenames = ['hiker.h', 'hiker.c', 'instructions','cyber-dojo.sh','makefile','output']
    filenames.each { |filename| assert visible_files.keys.include?(filename), filename }
    assert_equal '', tags[0].output
  end
  
  #- - - - - - - - - - - - - - - - - - -

  test '839D39',
  'each [test]-event creates a new tag' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal 1, lion.tags.length
    runner.stub_output('xxxx')
    maker = DeltaMaker.new(lion)
    maker.run_test
    maker.run_test
    maker.run_test
    assert_equal 4, lion.tags.length
    lion.tags.each_with_index{|tag,i| assert_equal i, tag.number }
  end
  
  #- - - - - - - - - - - - - - - - - - -

  test '8F2A42',
  'tags[-n] duplicates Array[-n] behaviour' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    runner.stub_output('xxxx')
    maker = DeltaMaker.new(lion)
    maker.run_test
    maker.run_test
    maker.run_test
    tags = lion.tags
    (1..tags.length).each {|i| assert_equal tags.length-i, tags[-i].number }
  end
    
end
