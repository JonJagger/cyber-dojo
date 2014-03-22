require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasKataTests < LinuxPaasModelTestCase

  def setup
    super()
    @id = '45ED23A2F1'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "id is from ctor" do
    json_and_rb do
      @kata = @dojo.katas[@id]
      assert_equal Id.new(@id), @kata.id
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false before dir is made" do
    json_and_rb do
      @kata = @dojo.katas[@id]
      assert !@kata.exists?
      @paas.dir(@kata).make
      assert @kata.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "make_kata with default-id and default-now creates unique-id and uses-time-now" do
    json_and_rb do
      @language = @dojo.languages['Java-JUnit']
      @paas.dir(@language).spy_read('manifest.json', JSON.unparse({
        :unit_test_framework => 'JUnit'
      }))
      @exercise = @dojo.exercises['Yahtzee']
      @paas.dir(@exercise).spy_read('instructions', 'your task...')
      now = Time.now
      past = Time.mktime(now.year, now.month, now.day, now.hour, now.min, now.sec)
      @kata = @dojo.make_kata(@language, @exercise)
      assert_not_equal @id, @kata.id
      created = Time.mktime(*@kata.created)
      diff = created - past
      assert 0 <= diff && diff < 1
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "make_kata saves manifest in kata dir" do
    json_and_rb do |format|
      @language = @dojo.languages['Java-JUnit']
      @paas.dir(@language).spy_read('manifest.json', JSON.unparse({
        :unit_test_framework => 'waffle'
      }))
      @exercise = @dojo.exercises['Yahtzee']
      @paas.dir(@exercise).spy_read('instructions', 'your task...')
      now = [2014,7,17,21,15,45]
      @kata = @dojo.make_kata(@language, @exercise, @id, now)

      expected_manifest = {
        :created => now,
        :id => @id,
        :language => @language.name,
        :exercise => @exercise.name,
        :unit_test_framework => 'waffle',
        :tab_size => 4,
        :visible_files => {
          'output' => '',
          'instructions' => 'your task...'
        }
      }
      if format == 'rb'
        assert @paas.dir(@kata).log.include?([ 'write', 'manifest.rb', expected_manifest.inspect ]),
          @paas.dir(@kata).log.inspect
      end
      if format == 'json'
        assert @paas.dir(@kata).log.include?([ 'write', 'manifest.json', JSON.unparse(expected_manifest) ]),
          @paas.dir(@kata).log.inspect
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "kata.id, kata.created, kata.language.name, kata.exercise.name, kata.visible_files all read from manifest" do
    json_and_rb do
      @language = @dojo.languages['C']
      visible_files = {
          'wibble.h' => '#include <stdio.h>',
          'wibble.c' => '#include "wibble.h"'
      }
      @paas.dir(@language).spy_read('manifest.json', JSON.unparse({
        :id => @id,
        :visible_filenames => visible_files.keys
      }))
      @paas.dir(@language).spy_read('wibble.h', visible_files['wibble.h'])
      @paas.dir(@language).spy_read('wibble.c', visible_files['wibble.c'])
      @exercise = @dojo.exercises['Yahtzee']
      @paas.dir(@exercise).spy_read('instructions', 'your task...')
      now = [2014,7,17,21,15,45]
      @kata = @dojo.make_kata(@language, @exercise, @id, now)
      assert_equal @id, @kata.id.to_s
      assert_equal Time.mktime(*now), @kata.created
      assert_equal @language.name, @kata.language.name
      assert_equal @exercise.name, @kata.exercise.name
      expected_visible_files = {
        'output' => '',
        'instructions' => 'your task...',
        'wibble.h' => visible_files['wibble.h'],
        'wibble.c' => visible_files['wibble.c'],
      }
      assert_equal expected_visible_files, @kata.visible_files
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "you can create an avatar in a kata" do
    you_can_create_an_avatar_in_a_kata('rb')
    you_can_create_an_avatar_in_a_kata('json')
  end

  def you_can_create_an_avatar_in_a_kata(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name
    }
    @kata = @dojo.create_kata(manifest)
    assert 'hippo', @kata['hippo'].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "multiple avatars in a kata are all seen" do
    multiple_avatars_in_a_kata_are_all_seen('rb')
    teardown
    setup
    multiple_avatars_in_a_kata_are_all_seen('json')
  end

  def multiple_avatars_in_a_kata_are_all_seen(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => {
        'name' => 'content for name'
      },
      :language => language.name
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    animal1 = kata.start_avatar
    animal2 = kata.start_avatar
    avatars = kata.avatars
    assert_equal 2, avatars.length
    assert_equal [animal1.name,animal2.name].sort, avatars.collect{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "start_avatar succeeds once for each avatar name then fails" do
    start_avatar_succeeds_once_for_each_avatar_then_fails('rb')
    teardown
    setup
    start_avatar_succeeds_once_for_each_avatar_then_fails('json')
  end

  def start_avatar_succeeds_once_for_each_avatar_then_fails(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name,
      :visible_files => {
        'wibble.h' => '#include <stdio.h>'
      }
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    created = [ ]
    Avatar.names.length.times do |n|
      avatar = kata.start_avatar
      assert_not_nil avatar
      created << avatar
    end
    assert_equal Avatar.names.length, created.collect{|avatar| avatar.name}.uniq.length
    avatar = kata.start_avatar
    assert_nil avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_manifest_spy_read(format, spied)
    if (format == 'rb')
      @paas.dir(@kata).spy_read('manifest.rb', spied.inspect)
    end
    if (format == 'json')
      @paas.dir(@kata).spy_read('manifest.json', JSON.unparse(spied))
    end
  end

  def kata_manifest_spy_write(format, spied)
    if (format == 'rb')
      @paas.dir(@kata).spy_write('manifest.rb', spied.inspect)
    end
    if (format == 'json')
      @paas.dir(@kata).spy_write('manifest.json', JSON.unparse(spied))
    end
  end
=end

end
