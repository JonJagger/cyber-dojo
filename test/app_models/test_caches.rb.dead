#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class CachesTests < AppModelsTestBase

  test 'F6CCC9',
  'caches path has correct format when set with trailing slash' do
    path = tmp_root + 'slashed/'
    set_caches_root(path)
    assert_equal path, caches.path
    assert correct_path_format?(caches)
  end

  #- - - - - - - - - - - - - - - -

  test 'C10B9D',
  'caches path has correct format when set without trailing slash' do
    path = tmp_root + 'unslashed'
    set_caches_root(path)
    assert_equal path + '/', caches.path
    assert correct_path_format?(caches)
  end

  #- - - - - - - - - - - - - - - -

  test '2177BF',
  'write_json, read_json round-trips' do
    set_caches_root(tmp_root + 'fake-caches')
    cache_filename = 'test_cache.json'
    caches.write_json(cache_filename, [0,1,2,3,4])
    array = caches.read_json(cache_filename)
    assert_equal 0, array[0]
  end

  #- - - - - - - - - - - - - - - -

  test '0289F2',
  'write_json_once() across multiple threads succeeds only once' do
    set_caches_root(tmp_root + 'fake-caches')
    cache_filename = '0289F2.json'
    25.times do |n|
      `rm -f #{caches.path}#{cache_filename}`
      size = 42
      threads = Array.new(size)
      called = Array.new(size, false)
      threads.size.times { |i|
        threads[i] = Thread.new {
          caches.write_json_once(cache_filename) {
            called[i] = true
            { "a"=>1, "b"=>2 }
          }
        }
      }
      threads.size.times { |i| threads[i].join }
      assert_equal 1, called.count(true), n.to_s
    end
  end

  #- - - - - - - - - - - - - - - -

  test '9D1EB1',
  'write_json_once() across multiple processes succeeds only once' do
    set_caches_root(tmp_root + 'fake-caches')
    cache_filename = '9D1EB1.json'
    13.times do |n|
      `rm -f #{caches.path}#{cache_filename}`
      read_pipe, write_pipe = IO.pipe
      pids = Array.new(15)
      pids.size.times { |i|
        pids[i] = Process.fork {
          caches.write_json_once(cache_filename) {
            write_pipe.puts i.to_s
            { "a"=>1, "b"=>2 }
          }
        }
      }
      pids.each { |pid| Process.wait(pid) }
      write_pipe.close
      called = read_pipe.read.split
      read_pipe.close
      assert_equal 1, called.size, called
    end
  end

  #- - - - - - - - - - - - - - - -

  # once() if json creation raises other waiting threads/processes are interrupted

end
