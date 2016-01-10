#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostDiskAvatarStarterTests < LibTestBase

  def setup
    super
    @kata = make_kata
  end

  def start_avatar(avatar_names = Avatars.names.shuffle)
    katas.kata_start_avatar(@kata, avatar_names)
  end

  def started_avatars
    katas.kata_started_avatars(@kata)
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
