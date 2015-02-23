#!/usr/bin/env ruby

require_relative 'integration_test_base'

class AvatarTests < IntegrationTestBase

  test 'deleted file is deleted from that repo tag' do
    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    deleted_filename = 'instructions'
    visible_files[deleted_filename] = 'Whatever'
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]
    }
    avatar.test(delta, visible_files)  # tag 1
    visible_files.delete(deleted_filename)
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ deleted_filename ],
      :new => [ ]
    }
    avatar.test(delta, visible_files)  # tag 2
    before = avatar.tags[1].visible_files
    assert before.keys.include?("#{deleted_filename}"),
          "before.keys.include?(#{deleted_filename})"
    after = avatar.tags[2].visible_files
    assert !after.keys.include?("#{deleted_filename}"),
          "!after.keys.include?(#{deleted_filename})"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'diff is not empty when change in files' do
    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]
     }
    avatar.test(delta, visible_files) # tag 1
    visible_files['cyber-dojo.sh'] += 'xxxx'
    delta = {
      :changed => [ 'cyber-dojo.sh' ],
      :unchanged => visible_files.keys - [ 'cyber-dojo.sh' ],
      :deleted => [ ],
      :new => [ ]
     }
    avatar.test(delta, visible_files) # tag 2
    traffic_lights = avatar.lights.each.entries
    assert_equal 2, traffic_lights.length
    diff = avatar.diff(1,2)
    added_line =
    {
      :type   => :added,
      :line   => 'xxxx',
      :number => 3
    }
    assert diff['cyber-dojo.sh'].include?(added_line), diff.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'diff shows added file' do
    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    added_filename = 'unforgiven.txt'
    content = 'starring Clint Eastwood'
    visible_files[added_filename] = content
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ added_filename ],
      :deleted => [ ],
      :new => [ added_filename ]
    }

    avatar.test(delta, visible_files) # 1

    diff = avatar.diff(0,1)
    added =
    [
       { :type=>:section, :index=>0
       },
       { :type   => :added,
         :line   => content,
         :number => 1
       }
    ]
    assert_equal added, diff[added_filename]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'diff shows deleted file' do
    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    deleted_filename = 'instructions'
    content = 'tweedle_dee'
    visible_files[deleted_filename] = content

    delta = {
      :changed => [ deleted_filename ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ ],
      :new => [ ]
    }
    avatar.test(delta, visible_files)  # tag 1
    #- - - - -
    visible_files.delete(deleted_filename)
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ deleted_filename ],
      :new => [ ]
    }
    avatar.test(delta, visible_files)  # tag 2
    #- - - - -
    diff = avatar.diff(1,2)
    deleted =
    [
      {
        :line   => content,
        :type   => :deleted,
        :number => 1
      }
    ]
    assert_equal deleted, diff[deleted_filename], diff.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'output is correct on refresh' do
    kata = make_kata(@dojo, 'Ruby-TestUnit')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files

    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }
    avatar.test(delta, visible_files)
    output = visible_files['output']

    # now refresh
    avatar = kata.avatars[avatar.name]
    assert_equal output, avatar.tags[1].output
  end

end
