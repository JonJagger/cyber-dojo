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
    repeat = 25
    repeat.times do |n|
      size = 42
      threads = Array.new(size)
      called = Array.new(size, false)
      `rm -f #{caches.path}#{cache_filename}`
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

  # once() across multiple processes succeeds only once
  # once() if json creation raises other waiting threads are interrupted

end
