#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostDiskAvatarStarterTests < LibTestBase

  def setup
    super
    @kata = make_kata
  end

  def start_avatar(avatar_names = Avatars.names.shuffle)
    history.kata_start_avatar(@kata, avatar_names)
  end

  def started_avatars
    history.kata_started_avatars(@kata)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0A5632',
  'started_avatars is initially empty array' do
    assert_equal [], started_avatars
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '449306',
  'start_avatar(names) starts first unstarted avatar in names' do
    avatar_name = start_avatar(['lion','panda','salmon'])
    assert_equal 'lion', avatar_name
    assert_equal ['lion'], started_avatars
    avatar_name = start_avatar(['lion','panda','salmon'])
    assert_equal 'panda', avatar_name
    assert_equal ['lion','panda'], started_avatars
    avatar_name = start_avatar(['lion','panda','salmon'])
    assert_equal 'salmon', avatar_name
    assert_equal ['lion','panda', 'salmon'], started_avatars
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C8549B',
  'start_avatar is nil when the dojo is full' do
    animals = ['lion','panda','salmon']
    animals.size.times do
      avatar_name = start_avatar(animals)
      refute_nil avatar_name
    end
    avatar_name = start_avatar(animals)
    assert_nil avatar_name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D6379A',
  'start_avatar is nil when the dojo is full (without default argument)' do
    Avatars.names.size.times do
      avatar_name = start_avatar
      refute_nil avatar_name
    end
    assert_equal Avatars.names, started_avatars
    avatar_name = start_avatar
    assert_nil avatar_name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4C08A1',
  'start_avatar on multiple threads doesnt start the same avatar twice' do
    # Have to call setup at the start of each loop
    # And have to make sure setups/teardowns balance.
    # See test/test_external_helpers.rb
    teardown
    repeat = 20
    repeat.times do |n|
      begin
        setup
        started = []
        semaphore = Mutex.new
        size = 4
        animals = Avatars.names[0...size].shuffle
        threads = Array.new(size * 2)
        names = Array.new(size * 2)
        threads.size.times { |i| threads[i] = Thread.new { names[i] = start_avatar(animals) } }
        threads.size.times { |i| threads[i].join }
        names.compact!
        assert_equal animals.sort, names.sort
        assert_equal names.sort, started_avatars
      ensure
        teardown if n != (repeat-1)
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A31DC1',
  'start_avatar on multiple processes doesnt start the same avatar twice' do
    # Have to call setup at the start of each loop
    # And have to make sure setups/teardowns balance.
    # See test/test_external_helpers.rb
    teardown
    repeat = 20
    20.times do |n|
      begin
        setup
        started = []
        size = 4
        animals = Avatars.names[0...size].shuffle
        names = Array.new(size * 2)
        read_pipe, write_pipe = IO.pipe
        names.size.times { Process.fork { write_pipe.puts start_avatar(animals) } }
        names.size.times { Process.wait }
        write_pipe.close
        names = read_pipe.read.split
        read_pipe.close
        assert_equal animals.sort, names.sort
        assert_equal names.sort, started_avatars
      ensure
        teardown if n != (repeat-1)
      end
    end
  end

end
