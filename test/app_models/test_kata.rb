#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class KataTests < ModelTestCase

  test 'path(kata)' do
    json_and_rb do
      kata = @dojo.katas[id]
      assert kata.path.include?(kata.id.inner)
      assert kata.path.include?(kata.id.outer)
      assert path_ends_in_slash?(kata)
      assert !path_has_adjacent_separators?(kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata does exist it is not active and its age is zero' do
    json_and_rb do
      kata = @dojo.katas[id]
      assert !kata.exists?
      assert !kata.active?
      assert_equal 0, kata.age
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists but has no avatars it is not active and its age is zero' do
    json_and_rb do
      kata = make_kata
      assert kata.exists?
      assert !kata.active?
      assert_equal 0, kata.age
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists but all its avatars have less than 2 traffic-lights ' +
       'then it is not active and its age is zero' do
    json_and_rb do |format|
      kata = make_kata
      hippo = kata.start_avatar(['hippo'])
      lion = kata.start_avatar(['lion'])
      lights_filename = lion.traffic_lights_filename

      light =
      [
        {
          'colour' => 'red',
          'time' => [2014, 2, 15, 8, 54, 6],
          'number' => 1
        }
      ]
      if format === 'rb'
        hippo.dir.spy_read(lights_filename, light.inspect)
      end
      if format === 'json'
        hippo.dir.spy_read(lights_filename, JSON.unparse(light))
      end

      assert !kata.active?
      assert_equal 0, kata.age
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when kata exists and at least one avatar has 2 or more traffic-lights ' +
       'then kata is active and age is from earliest 2nd traffic-light to now' do
    json_and_rb do |format|
      kata = make_kata
      hippo = kata.start_avatar(['hippo'])
      lion = kata.start_avatar(['lion'])
      lights_filename = lion.traffic_lights_filename
      auto =
        {
          'colour' => 'red',
          'time' => [2014, 2, 15, 8, 54, 6],
          'number' => 1
        }

      manual =
        {
          'colour' => 'green',
          'time' => [2014, 2, 15, 8, 54, 34],
          'number' => 2
        }

      if format === 'rb'
        hippo.dir.spy_read(lights_filename, [auto].inspect)
        lion.dir.spy_read(lights_filename, [auto,manual].inspect)
      end
      if format === 'json'
        hippo.dir.spy_read(lights_filename, JSON.unparse([auto]))
        lion.dir.spy_read(lights_filename, JSON.unparse([auto,manual]))
      end

      assert kata.active?
      now = manual["time"]
      now[5] += 17
      assert_equal 17, kata.age(now)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id read back as set' do
    json_and_rb do
      kata = @dojo.katas[id]
      assert_equal Id.new(id), kata.id
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false for empty-string id' do
    json_and_rb do
      kata = @dojo.katas[id='']
      assert !kata.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false before dir is made' do
    json_and_rb do
      kata = @dojo.katas[id]
      assert !kata.exists?
      @disk[kata.path].make
      assert kata.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'make_kata with default-id and default-now' +
       ' creates unique-id and uses-time-now' do
    json_and_rb do
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
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'make_kata saves manifest in kata dir' do
    json_and_rb do |format|
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
      if format == 'rb'
        assert kata.dir.log.include?([ 'write', 'manifest.rb', expected_manifest.inspect ]),
          kata.dir.log.inspect
      end
      if format == 'json'
        assert kata.dir.log.include?([ 'write', 'manifest.json', JSON.unparse(expected_manifest) ]),
          kata.dir.log.inspect
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'kata.id, kata.created, kata.language.name,' +
       ' kata.exercise.name, kata.visible_files' +
       ' all read from manifest' do
    json_and_rb do
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
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar with specific avatar-name (useful for testing)' do
    json_and_rb do
      kata = make_kata
      avatar = kata.start_avatar(['hippo'])
      assert_equal 'hippo', avatar.name
      assert_equal ['hippo'], kata.avatars.map {|avatar| avatar.name}
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar with specific avatar-names arg is use (useful for testing)' do
    json_and_rb do
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
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'start_avatar succeeds once for each avatar name then fails' do
    json_and_rb do
      kata = make_kata
      created = [ ]
      Avatar.names.length.times do |n|
        avatar = kata.start_avatar
        assert_not_nil avatar
        created << avatar
      end
      assert_equal Avatar.names.sort, created.collect{|avatar| avatar.name}.sort
      avatar = kata.start_avatar
      assert_nil avatar
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'old kata with rb manifest file reports its format as rb' do
    json_and_rb do
      id = '12345ABCDE'
      kata = Kata.new(@dojo.katas, id)
      kata.dir.make
      kata.dir.spy_exists?('manifest.rb')
      assert_equal 'rb', kata.format
      assert kata.format === 'rb'
      assert_equal 'manifest.rb', kata.manifest_filename
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'kata without manifest yet (viz not started) ' +
       " reports its manifest_filename as having parent dojo's format" do
    json_and_rb do |format|
      id = '12345ABCDE'
      kata = Kata.new(@dojo.katas, id)
      assert_equal format, kata.format
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id
    '45ED23A2F1'
  end

end
