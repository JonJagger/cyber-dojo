#!/usr/bin/env ruby

require_relative 'integration_test_base'

class DockerTestRunnerAdapter
  def initialize(adaptee)
    @runner = adaptee
  end
  def runnable?(language)
    @runner.runnable?(language)
  end
  def run(sandbox,command,max_seconds)
    @runner.inner_run(sandbox,command,max_seconds)
  end
end

class DockerTestRunnerTests < IntegrationTestBase

  include TimeNow

  def runner
    DockerTestRunner.new
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "DockerTestRunner when outer and inner commands do not timeout" do
    return if !Docker.installed?
    dojo = Dojo.new
    kata = make_kata(dojo, 'C-assert')
    lion = kata.start_avatar(['lion'])
    visible_files = lion.tags[0].visible_files
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]
    }
    rags,_,_ = lion.test(delta, visible_files)
    assert_equal 'red', rags[-1]['colour']
    assert_equal '', `docker ps -a -q`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "DockerTestRunner when inner command times out" do
    return if !Docker.installed?
    dojo = Dojo.new
    kata = make_kata(dojo, 'C-assert')
    lion = kata.start_avatar(['lion'])
    visible_files = lion.tags[0].visible_files
    source = visible_files['hiker.c']
    visible_files['hiker.c'] = source.sub('{', '{for(;;);')
    delta = {
      :changed => [ 'hiker.c' ],
      :unchanged => visible_files.keys - [ 'hiker.c' ],
      :deleted => [ ],
      :new => [ ]
    }
    rags,_,_ = lion.test(delta, visible_files, time_now, 2)
    output = lion.tags[1].visible_files['output']
    assert output.start_with?('Unable to complete the tests in 2 seconds')
    assert_equal 'timed_out', rags[-1]['colour']
    assert_equal '', `docker ps -a -q`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "DockerTestRunner when outer command times out " +
       "(simulates breaking out of the docker container)" do
    return if !Docker.installed?
    thread[:runner] = DockerTestRunnerAdapter.new(runner)
    dojo = Dojo.new
    kata = make_kata(dojo, 'C-assert')
    lion = kata.start_avatar(['lion'])
    visible_files = lion.tags[0].visible_files
    source = visible_files['hiker.c']
    visible_files['hiker.c'] = source.sub('{', '{for(;;);')
    delta = {
      :changed => [ 'hiker.c' ],
      :unchanged => visible_files.keys - [ 'hiker.c' ],
      :deleted => [ ],
      :new => [ ]
    }
    rags,_,_ = lion.test(delta, visible_files, time_now, 2)
    output = lion.tags[1].visible_files['output']
    assert output.start_with?('Unable to complete the tests in 2 seconds')
    assert_equal 'timed_out', rags[-1]['colour']
    assert_equal '', `docker ps -a -q`
  end

end
