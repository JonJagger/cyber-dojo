#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class DockerTestRunnerTests < CyberDojoTestBase

  include TimeNow

  def externals(runner)
    {
      :disk   => OsDisk.new,
      :git    => Git.new,
      :runner => runner
    }
  end

  def runner
    assert Docker.installed?
    DockerTestRunner.new
  end

  def setup
    super
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "DockerTestRunner when outer and inner commands do not timeout" do
    dojo = Dojo.new(root_path,externals(runner))
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
    dojo = Dojo.new(root_path,externals(runner))
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

  #I can wrap runner so runner.run (as called
  #in avatar.test) can be adapted and call
  #adapted runner.inner_run when I need to bypass
  #the inner timeout

end
