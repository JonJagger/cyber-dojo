#!/usr/bin/env ruby

require_relative 'integration_test_base'

class GitDiffViewTests < IntegrationTestBase

  include GitDiff

  test 'building git diff view from repo with deleted file' do

    language = @dojo.languages['C-assert']
    exercise = @dojo.exercises['Yatzy']
    kata = @dojo.katas.create_kata(language, exercise)
    avatar = kata.start_avatar # tag 0

    visible_files = avatar.tags[0].visible_files
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]
    }

    avatar.test(delta, visible_files) # tag 1

    assert_equal :red, avatar.lights[-1].colour,
                       avatar.tags[1].output

    deleted_filename = 'hiker.h'
    assert visible_files.keys.include?(deleted_filename)
    deleted_file_content = visible_files[deleted_filename]
    visible_files.delete(deleted_filename)

    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ deleted_filename ],
      :new => [ ]
    }

    avatar.test(delta, visible_files) # tag 2

    assert_equal :amber, avatar.lights[-1].colour,
                         kata.id + ":" + avatar.tags[-1].output

    diff = avatar.diff(was_tag=1,now_tag=2)
    diff.delete('output')

    expected = deleteify(LineSplitter.line_split(deleted_file_content))

    assert_equal expected, diff[deleted_filename]
  end

  #-----------------------------------------------

  test 'only visible files are commited and are seen in diff_lines' do

    language = @dojo.languages['Ruby-TestUnit']
    exercise = @dojo.exercises['Yatzy']
    kata = @dojo.katas.create_kata(language, exercise)
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files

    visible_files['cyber-dojo.sh'] += "\necho xxx > jj.extra"
    delta = {
      :changed => [ 'cyber-dojo.sh' ],
      :unchanged => visible_files.keys - [ 'cyber-dojo.sh' ],
      :deleted => [ ],
      :new => [ ]
    }
    avatar.test(delta, visible_files) # tag 1

    assert avatar.sandbox.dir.exists?('jj.extra')

    diff = avatar.diff(was_tag=0,now_tag=1)
    diff.keys.each do |filename|
      assert visible_files.keys.include?(filename),
            "visible_files.keys.include?(#{filename})"
    end

    assert_equal visible_files.length, diff.length
  end

end
