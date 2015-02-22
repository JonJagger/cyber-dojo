#!/usr/bin/env ruby

require_relative 'integration_test_base'

class SandboxTests < IntegrationTestBase

  test 'defect-driven: filename containing space ' +
       'is not accidentally retained in the sandbox' do

    kata = make_kata(@dojo, 'C-assert')
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

    filenames = visible_files.keys
    filename_base = 'hiker'
    ext = '.c'
    filename = filename_base + ext
    space = ' '
    filename_with_space = filename_base + space + ext
    assert filenames.include?(filename)
    content = visible_files[filename]

    visible_files.delete(filename)
    visible_files[filename_with_space] =  content

    delta = {
      :unchanged => filenames - [ filename ],
      :changed   => [ ],
      :deleted   => [ filename ],
      :new       => [ filename_with_space ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 2, lights.length
    assert_equal :amber, lights[-1].colour

    #- - - - - - - -
    # put it back the way it was

    visible_files.delete(filename_with_space)
    visible_files[filename] = content

    delta = {
      :changed   => [ ],
      :unchanged => visible_files.keys - [ filename ],
      :deleted   => [ filename_with_space ],
      :new       => [ filename ]
    }

    avatar.test(delta, visible_files)

    lights = avatar.lights
    assert_equal 3, lights.length
    assert_equal :red, lights[-1].colour

  end

end
