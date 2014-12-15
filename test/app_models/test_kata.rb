#!/usr/bin/env ruby

require_relative 'model_test_base'

class KataTests < ModelTestBase

  test 'attempting to create a Kata with an invalid id raises' do
    bad_ids = [
      nil,          # not string
      Object.new,   # not string
      '',           # too short
      '123456789',  # too short
      '123456789f', # not 0-9A-F
      '123456789S'  # not 0-9A-F
    ]
    bad_ids.each do |bad_id|
      assert_raises(RuntimeError) { @dojo.katas[bad_id] }
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id read back as set' do
    kata = @dojo.katas[id]
    assert_equal id, kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path is split ala git' do
    kata = @dojo.katas[id]
    assert kata.path.include?(kata.id[0..1])
    assert kata.path.include?(kata.id[2..-1])
    assert path_ends_in_slash?(kata)
    assert !path_has_adjacent_separators?(kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata does exist it is not active ' +
       'and its age is zero' do
    kata = @dojo.katas[id]
    assert !kata.exists?
    assert !kata.active?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists but has no avatars ' +
       'then it is not active ' +
       'and its age is zero' do
    kata = make_kata
    assert kata.exists?
    assert !kata.active?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists but all its avatars have 0 traffic-lights ' +
       'then it is not active ' +
       'and its age is zero' do
    kata = make_kata
    kata.start_avatar(['hippo'])
    kata.start_avatar(['lion'])

    assert !kata.active?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists and at least one avatar has 1 or more traffic-lights ' +
       'then kata is active ' +
       'and age is from earliest traffic-light to now' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    lion = kata.start_avatar(['lion'])
    first =
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      }

    second =
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      }

    hippo.dir.spy_read('increments.json', JSON.unparse([second]))
    lion.dir.spy_read('increments.json', JSON.unparse([first]))

    assert kata.active?
    now = first["time"]
    now[5] += 17
    assert_equal 17, kata.age(now)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false before dir is made' do
    kata = @dojo.katas[id]
    assert !kata.exists?
    @disk[kata.path].make
    assert kata.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'make_kata with default-id and default-now ' +
       'creates unique-id and uses-time-now' do
    language = @dojo.languages['Java-JUnit']
    language.dir.spy_read('manifest.json', {
      :unit_test_framework => 'JUnit'
    })
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.spy_read('instructions', 'your task...')
    now = Time.now
    past = Time.mktime(now.year, now.month, now.day, now.hour, now.min, now.sec)
    kata = @dojo.katas.create_kata(language, exercise)
    assert_not_equal id, kata.id
    created = Time.mktime(*kata.created)
    diff = created - past
    assert 0 <= diff && diff <= 1, "created=#{created}, past=#{past}, diff=#{past}"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'make_kata saves manifest in kata dir' do
    language = @dojo.languages['Java-JUnit']
    language.dir.spy_read('manifest.json', {
      :unit_test_framework => 'waffle'
    })
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.spy_read('instructions', 'your task...')
    now = [2014,7,17,21,15,45]
    kata = @dojo.katas.create_kata(language, exercise, id, now)

    expected_manifest = {
      :created => now,
      :id => id,
      :language => language.name,
      :exercise => exercise.name,
      :unit_test_framework => 'waffle',
      :tab_size => 4,
      :visible_files => {
        'output' => '',
        'instructions' => 'your task...'
      }
    }
    assert kata.dir.log.include?([ 'write', 'manifest.json', JSON.unparse(expected_manifest) ]),
      kata.dir.log.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'kata.id, kata.created, kata.language.name, ' +
       'kata.exercise.name, kata.visible_files ' +
       'all read from manifest' do
    language = @dojo.languages['test-C++-catch']
    visible_files = {
        'wibble.hpp' => '#include <iostream>',
        'wibble.cpp' => '#include "wibble.hpp"'
    }
    language.dir.spy_read('manifest.json', {
      :visible_filenames => visible_files.keys
    })
    language.dir.spy_read('wibble.hpp', visible_files['wibble.hpp'])
    language.dir.spy_read('wibble.cpp', visible_files['wibble.cpp'])
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.spy_read('instructions', 'your task...')
    now = [2014,7,17,21,15,45]
    kata = @dojo.katas.create_kata(language, exercise, id, now)
    assert_equal id, kata.id.to_s
    assert_equal Time.mktime(*now), kata.created
    assert_equal language.name, kata.language.name
    assert_equal exercise.name, kata.exercise.name
    expected_visible_files = {
      'output' => '',
      'instructions' => 'your task...',
      'wibble.hpp' => visible_files['wibble.hpp'],
      'wibble.cpp' => visible_files['wibble.cpp'],
    }
    assert_equal expected_visible_files, kata.visible_files
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar with specific avatar-name ' +
       '(useful for testing)' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    assert_equal 'hippo', hippo.name
    assert_equal ['hippo'], kata.avatars.map {|avatar| avatar.name}
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar with specific avatar-names arg is used ' +
       '(useful for testing)' do
    kata = make_kata
    names = [ 'panda', 'lion', 'cheetah' ]
    panda = kata.start_avatar(names)
    assert_equal 'panda', panda.name
    lion = kata.start_avatar(names)
    assert_equal 'lion', lion.name
    cheetah = kata.start_avatar(names)
    assert_equal 'cheetah', cheetah.name
    assert_equal nil, kata.start_avatar(names)
    avatars_names = kata.avatars.map {|avatar| avatar.name}
    assert_equal names.sort, avatars_names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar succeeds once for each avatar name then fails' do
    kata = make_kata
    created = [ ]
    Avatars.names.length.times do |n|
      avatar = kata.start_avatar
      assert_not_nil avatar
      created << avatar
    end
    assert_equal Avatars.names.sort, created.collect{|avatar| avatar.name}.sort
    avatar = kata.start_avatar
    assert_nil avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id
    '45ED23A2F1'
  end

end
