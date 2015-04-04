#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class DockerParseTests < AppLibTestBase

  test 'parse `docker images` output in prep for languages_each()' do
    output = [
      'REPOSITORY                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE',
      'cyberdojo/language_ruby-1.9.3         latest              48f93a0a2bb4        3 hours ago         328.3 MB',
      'cyberdojo/language_gcc-4.8.1_assert   latest              e8ac00b6fa7b        3 hours ago         310.6 MB',
      'cyberdojo/language_gpp-4.8.1_assert   latest              e8ac00b6fa7b        3 hours ago         310.6 MB',
      'cyberdojo/build-essential             latest              bc54c666c7c1        6 hours ago         310.6 MB',
      'ubuntu                                13.10               9f676bd305a4        7 weeks ago         178 MB',
      'ubuntu                                saucy               9f676bd305a4        7 weeks ago         178 MB',
    ].join("\n")

    assert_equal [
      'cyberdojo/build-essential',
      'cyberdojo/language_ruby-1.9.3',
      'cyberdojo/language_gcc-4.8.1_assert',
      'cyberdojo/language_gpp-4.8.1_assert',
      'ubuntu'
    ].sort, DockerTestRunner.new.image_names(output)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'parse `docker images` when none installed' do
    output =
      'REPOSITORY                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE'
    assert_equal [ ], DockerTestRunner.new.image_names(output)
  end

end
