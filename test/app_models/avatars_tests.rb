__DIR__ = File.dirname(__FILE__) + '/../../'
require __DIR__ + 'test/test_helper'
require __DIR__ + 'lib/OsDisk'
require __DIR__ + 'lib/Git'
require __DIR__ + 'app/lib/RawRunner'

class AvatarsTests < ActionController::TestCase

  def setup
    @disk   = OsDisk.new
    @git    = Git.new
    @runner = RawRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path, @format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
    @kata = @dojo.make_kata(@language, @exercise)
    @max_duration = 15
  end

  def now
    tn = Time.now
    [tn.year, tn.month, tn.day, tn.hour, tn.min, tn.sec]
  end

  test "avatar names all begin with a different letter" do
    assert_equal Avatar.names.collect{|name| name[0]}.uniq.length, Avatar.names.length
  end

  test "format" do
    avatar = @kata.start_avatar
    assert_equal @format, avatar.format
    assert !avatar.format_is_rb?
    assert avatar.format_is_json?
  end

  test "kata.avatars() returns all avatars started in the kata" do
    avatar1 = @kata.start_avatar
    avatar2 = @kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = @kata.avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars() returns all avatars started in kata with given id" do
    avatar1 = @kata.start_avatar
    avatar2 = @kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = @dojo.katas[@kata.id.to_s].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars[name] finds avatar with given name" do
    avatar = @kata.start_avatar
    name = avatar.name
    names = @kata.avatars.map{|avatar| avatar.name}
    assert_equal [name], names
    avatar = @dojo.katas[@kata.id.to_s].avatars[name]
    assert_equal name, avatar.name
  end

  test "avatar.test() initial output" do
    avatar = @kata.start_avatar
    output = avatar.test(@max_duration)
    assert output.include?('java.lang.AssertionError: expected:<54> but was:<42>')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar.save(:changed).test().save_traffic_light().commit().traffic_lights().diff_lines()" do
    avatar = @kata.start_avatar
    visible_files = avatar.visible_files
    assert_equal visible_files, avatar.visible_files(tag=0)
    assert_equal [ ], avatar.traffic_lights
    assert_equal [ ], avatar.traffic_lights(tag=0)

    filename = 'UntitledTest.java'
    test_code = visible_files[filename];
    assert test_code.include?('6 * 9')
    test_code.sub!('6 * 9', '6 * 7')
    visible_files[filename] = test_code
    delta = {
      :deleted => [ ],
      :changed => [ filename ],
      :new => [ ],
      :unchanged => visible_files.keys - [ filename ]
    }
    visible_files.delete('output')
    avatar.save(delta, visible_files)
    output = avatar.test(@max_duration)
    assert output.include?('OK (1 test)')

    avatar.sandbox.write('output',output)
    visible_files['output'] = output
    avatar.save_visible_files(visible_files)
    traffic_light = { 'colour' => 'green' }
    traffic_lights = avatar.save_traffic_light(traffic_light, now)

    assert_equal traffic_lights, avatar.traffic_lights
    assert_not_nil traffic_lights
    assert_equal 1, traffic_lights.length

    avatar.commit(traffic_lights.length)
    assert_equal traffic_lights, avatar.traffic_lights
    assert_equal traffic_lights, avatar.traffic_lights(tag=1)

    diff = avatar.diff_lines(was_tag=0, now_tag=1)
    assert diff.include?("diff --git a/sandbox/#{filename} b/sandbox/#{filename}"), diff
    assert diff.include?('-        int expected = 6 * 9;'), diff
    assert diff.include?('+        int expected = 6 * 7;'), diff
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar.save(:deleted).test().save_traffic_light().commit().traffic_lights().diff_lines()" do
    avatar = @kata.start_avatar
    visible_files = avatar.visible_files
    filename = 'Untitled.java'
    visible_files.keys.delete(filename)
    delta = {
      :deleted => [ filename ],
      :changed => [ ],
      :new => [ ],
      :unchanged => visible_files.keys - [ filename ]
    }
    visible_files.delete('output')
    avatar.save(delta, visible_files)
    output = avatar.test(@max_duration)
    assert output.include?('UntitledTest.java:9: cannot find symbol')

    avatar.sandbox.write('output',output)
    visible_files['output'] = output
    avatar.save_visible_files(visible_files)
    traffic_light = { 'colour' => 'amber' }
    traffic_lights = avatar.save_traffic_light(traffic_light, now)
    assert_equal traffic_lights, avatar.traffic_lights
    assert_not_nil traffic_lights
    assert_equal 1, traffic_lights.length
    avatar.commit(traffic_lights.length)
    diff = avatar.diff_lines(was_tag=0, now_tag=1)
    assert diff.include?('--- a/sandbox/Untitled.java'), diff
    assert diff.include?('+++ /dev/null'), diff
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar.save(:new).test().save_traffic_light().commit().traffic_lights().diff_lines()" do
    avatar = @kata.start_avatar
    visible_files = avatar.visible_files
    filename = 'Wibble.java'
    visible_files[filename] = 'public class Wibble {}'
    delta = {
      :deleted => [ ],
      :changed => [ ],
      :new => [ filename ],
      :unchanged => visible_files.keys - [ filename ]
    }
    visible_files.delete('output')
    avatar.save(delta, visible_files)
    output = avatar.test(@max_duration)
    assert output.include?('java.lang.AssertionError: expected:<54> but was:<42>')

    avatar.sandbox.write('output',output)
    visible_files['output'] = output
    avatar.save_visible_files(visible_files)
    traffic_light = { 'colour' => 'red' }
    traffic_lights = avatar.save_traffic_light(traffic_light, now)
    assert_equal traffic_lights, avatar.traffic_lights
    assert_not_nil traffic_lights
    assert_equal 1, traffic_lights.length
    avatar.commit(traffic_lights.length)
    diff = avatar.diff_lines(was_tag=0, now_tag=1)
    assert diff.include?('--- /dev/null'), diff
    assert diff.include?('+++ b/sandbox/Wibble.java'), diff
  end

end
