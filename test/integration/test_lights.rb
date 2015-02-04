#!/usr/bin/env ruby

require_relative 'integration_test_base'

class LightsTests < IntegrationTestBase

  include TimeNow

  def setup
    super
    @language = @dojo.languages['Ruby-MiniTest']
    @exercise = @dojo.exercises['Yatzy']
    @kata = @dojo.katas.create_kata(@language, @exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar.lights initially empty' do
    lights = @kata.start_avatar.lights
    assert_equal [], lights.entries
    assert_equal 0, lights.count
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar.save(:changed).test().lights().diff()' do
    avatar = @kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    assert_equal [ ], avatar.lights.each.entries


    delta = {
      :deleted => [ ],
      :changed => [ ],
      :new => [ ],
      :unchanged => [ ]
    }
    lights,_,_ = avatar.test(delta, visible_files, now = time_now)
    assert_equal 1, lights.count
    assert_equal 'red', lights[-1]['colour']
    assert_equal now, lights[-1]['time']
    assert_equal 1, lights[-1]['number']

    filename = 'hiker.rb'
    code = visible_files[filename];
    assert code.include?('6 * 9')
    code.sub!('6 * 9', '6 * 7')
    visible_files[filename] = code
    delta = {
      :deleted => [ ],
      :changed => [ filename ],
      :new => [ ],
      :unchanged => visible_files.keys - [ filename ]
    }

    visible_files.delete('output')

    lights,_,_ = avatar.test(delta, visible_files, now = time_now)
    assert_equal 2, lights.count
    assert_equal 'green', lights[-1]['colour']
    assert_equal now, lights[-1]['time']
    assert_equal 2, lights[-1]['number']

    diff = avatar.tags[1].diff(2)

    deleted_line =
    {
      :type   => :deleted,
      :line   => '  6 * 9',
      :number => 3
    }
    added_line =
    {
      :type   => :added,
      :line   => '  6 * 7',
      :number => 3
    }
    assert diff[filename].include?(added_line), diff[filename].inspect
    assert diff[filename].include?(deleted_line), diff[filename].inspect

  end

=begin
  test "xxxx" do
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
    avatar.save_manifest(visible_files)
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
    avatar.save_manifest(visible_files)
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
=end

end
