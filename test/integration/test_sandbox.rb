#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class SandboxTests < CyberDojoTestBase

  include Externals

  def setup
    super
    set_externals
    @dojo = Dojo.new(root_path)
  end

  test 'defect-driven: filename containing space ' +
       'is not accidentally retained in the sandbox' do

    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
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
    assert filenames.include?('hiker.rb')
    content = visible_files['hiker.rb']

    visible_files.delete('hiker.rb')
    visible_files['hiker' + SPACE + '.rb'] =  content

    delta = {
      :unchanged => filenames - [ 'hiker.rb' ],
      :changed   => [ ],
      :deleted   => [ 'hiker.rb' ],
      :new       => [ 'hiker' + SPACE + '.rb' ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 2, lights.length
    assert_equal :amber, lights[-1].colour

    #- - - - - - - -
    # put it back the way it was

    visible_files.delete('hiker' + SPACE + '.rb')
    visible_files['hiker.rb'] = content

    delta = {
      :changed   => [ ],
      :unchanged => visible_files.keys - [ 'hiker.rb' ],
      :deleted   => [ 'hiker' + SPACE + '.rb' ],
      :new       => [ 'hiker.rb' ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 3, lights.length
    assert_equal :red, lights[-1].colour

  end

end
