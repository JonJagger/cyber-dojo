require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasKataTests < LinuxPaasModelTestCase

  test "id is from ctor" do
    json_and_rb do
      kata = @dojo.katas[id]
      assert_equal Id.new(id), kata.id
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false before dir is made" do
    json_and_rb do
      kata = @dojo.katas[id]
      assert !kata.exists?
      @paas.dir(kata).make
      assert kata.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "make_kata with default-id and default-now creates unique-id and uses-time-now" do
    json_and_rb do
      language = @dojo.languages['Java-JUnit']
      @paas.dir(language).spy_read('manifest.json', JSON.unparse({
        :unit_test_framework => 'JUnit'
      }))
      exercise = @dojo.exercises['Yahtzee']
      @paas.dir(exercise).spy_read('instructions', 'your task...')
      now = Time.now
      past = Time.mktime(now.year, now.month, now.day, now.hour, now.min, now.sec)
      kata = @dojo.make_kata(language, exercise)
      assert_not_equal id, kata.id
      created = Time.mktime(*kata.created)
      diff = created - past
      assert 0 <= diff && diff < 1
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "make_kata saves manifest in kata dir" do
    json_and_rb do |format|
      language = @dojo.languages['Java-JUnit']
      @paas.dir(language).spy_read('manifest.json', JSON.unparse({
        :unit_test_framework => 'waffle'
      }))
      exercise = @dojo.exercises['Yahtzee']
      @paas.dir(exercise).spy_read('instructions', 'your task...')
      now = [2014,7,17,21,15,45]
      kata = @dojo.make_kata(language, exercise, id, now)

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
        assert @paas.dir(kata).log.include?([ 'write', 'manifest.rb', expected_manifest.inspect ]),
          @paas.dir(kata).log.inspect
      end
      if format == 'json'
        assert @paas.dir(kata).log.include?([ 'write', 'manifest.json', JSON.unparse(expected_manifest) ]),
          @paas.dir(kata).log.inspect
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "kata.id, kata.created, kata.language.name, kata.exercise.name, kata.visible_files all read from manifest" do
    json_and_rb do
      language = @dojo.languages['C']
      visible_files = {
          'wibble.h' => '#include <stdio.h>',
          'wibble.c' => '#include "wibble.h"'
      }
      @paas.dir(language).spy_read('manifest.json', JSON.unparse({
        :visible_filenames => visible_files.keys
      }))
      @paas.dir(language).spy_read('wibble.h', visible_files['wibble.h'])
      @paas.dir(language).spy_read('wibble.c', visible_files['wibble.c'])
      exercise = @dojo.exercises['Yahtzee']
      @paas.dir(exercise).spy_read('instructions', 'your task...')
      now = [2014,7,17,21,15,45]
      kata = @dojo.make_kata(language, exercise, id, now)
      assert_equal id, kata.id.to_s
      assert_equal Time.mktime(*now), kata.created
      assert_equal language.name, kata.language.name
      assert_equal exercise.name, kata.exercise.name
      expected_visible_files = {
        'output' => '',
        'instructions' => 'your task...',
        'wibble.h' => visible_files['wibble.h'],
        'wibble.c' => visible_files['wibble.c'],
      }
      assert_equal expected_visible_files, kata.visible_files
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "you can create an avatar in a kata" do
    json_and_rb do
      kata = make_kata
      avatar = kata.start_avatar(['hippo'])
      assert_equal 'hippo', avatar.name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "multiple avatars in a kata are all seen" do
    json_and_rb do
      kata = make_kata
      names = [ 'panda', 'lion' ]
      panda = kata.start_avatar(names)
      lion = kata.start_avatar(names)
      avatars_names = kata.avatars.map {|avatar| avatar.name}
      assert_equal ['lion','panda'], avatars_names.sort
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "start_avatar succeeds once for each avatar name then fails" do
    json_and_rb do
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
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_kata
    language = @dojo.languages['C']
    visible_files = {
        'wibble.h' => '#include <stdio.h>',
        'wibble.c' => '#include "wibble.h"'
    }
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({
      :visible_filenames => visible_files.keys
    }))
    @paas.dir(language).spy_read('wibble.h', visible_files['wibble.h'])
    @paas.dir(language).spy_read('wibble.c', visible_files['wibble.c'])
    exercise = @dojo.exercises['Yahtzee']
    @paas.dir(exercise).spy_read('instructions', 'your task...')
    @dojo.make_kata(language, exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id
    '45ED23A2F1'
  end

end
