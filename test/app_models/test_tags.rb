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

    # starting an avatar causes commit tag=0 with
    # initial visible files. However the SpyGit does
    # not (yet) map the git.commits to the git.shows
    # so I have to cheat...

    manifest = JSON.unparse({
      f1='Hiker.cs' => f1_content='public class Hiker { }',
      f2='HikerTest.cs' => f2_content='using NUnit.Framework;'
    })
    n = 0
    filename = 'manifest.json'
    git.spy(avatar.dir.path,'show',"#{n}:#{filename}",manifest)

    visible_files = tags[0].visible_files
    assert_equal [f1,f2], visible_files.keys.sort
    assert_equal f1_content, visible_files[f1]
    assert_equal f2_content, visible_files[f2]
    assert_equal '', tags[0].output
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'each [test]-event creates a new tag' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    fake_three_tests(lion)

    tags = lion.tags
    assert_equal 4, tags.count
    assert tags.all?{|tag| tag.class.name === 'Tag'}

    # simulate green [test]
    manifest = JSON.unparse({
      f1='Hiker.cs' => f1_content='public class Hiker { }',
      f2='HikerTest.cs' => f2_content='using NUnit.Framework;',
      f3='output' => 'Tests run: 1, Failures: 0'
    })
    n = 2
    filename = 'manifest.json'
    git.spy(lion.dir.path,'show',"#{n}:#{filename}",manifest)

    visible_files = tags[n].visible_files
    assert_equal [f1,f2,f3], visible_files.keys.sort
    assert_equal f1_content, visible_files[f1]
    assert_equal f2_content, visible_files[f2]
  end

  #- - - - - - - - - - - - - - - - - - -

  def fake_three_tests(avatar)
    incs =
    [
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 55, 7],
        'number' => 3
      }
    ]
    avatar.dir.write('increments.json', incs)
  end

end
