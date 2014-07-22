#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class SandboxTests < CyberDojoTestBase

  include Externals
  include TimeNow

  def setup
    super
    @dojo = Dojo.new(root_path,externals)
  end

  test 'defect-driven: filename containing space ' +
       'is not accidentally retained in the sandbox' do

    kata = make_kata(@dojo, 'Java-1.8_JUnit')
    avatar = kata.start_avatar
    sandbox = avatar.sandbox

    visible_files = avatar.tags[0].visible_files

    delta = {
      :unchanged => visible_files.keys,
      :changed   => [ ],
      :deleted   => [ ],
      :new       => [ ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 1, lights.length
    assert_equal :red, lights[-1].colour

    #- - - - - - - -

    SPACE = ' '
    filenames = visible_files.keys
    assert filenames.include?('Hiker.java')
    content = visible_files['Hiker.java']

    visible_files.delete('Hiker.java')
    visible_files['Hiker' + SPACE + '.java'] =  content

    delta = {
      :unchanged => filenames - [ 'Hiker.java' ],
      :changed   => [ ],
      :deleted   => [ 'Hiker.java' ],
      :new       => [ 'Hiker' + SPACE + '.java' ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 2, lights.length
    assert_equal :amber, lights[-1].colour

    #- - - - - - - -
    # put it back the way it was

    visible_files.delete('Hiker' + SPACE + '.java')
    visible_files['Hiker.java'] = content

    delta = {
      :changed   => [ ],
      :unchanged => visible_files.keys - [ 'Hiker.java' ],
      :deleted   => [ 'Hiker' + SPACE + '.java' ],
      :new       => [ 'Hiker.java' ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 3, lights.length
    assert_equal :red, lights[-1].colour

  end

end
