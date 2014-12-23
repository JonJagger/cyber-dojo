#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class GitDiffViewTests < CyberDojoTestBase

  include Externals
  include GitDiff

  def setup
    super
    set_externals
    @dojo = Dojo.new(root_path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'building diff view from git repo with modified file' do

    language = @dojo.languages['Ruby-TestUnit']
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

    visible_files['hiker.rb'].sub!('6 * 9','6 * 7')
    delta = {
      :changed => [ 'hiker.rb' ],
      :unchanged => visible_files.keys - [ 'hiker.rb' ],
      :deleted => [ ],
      :new => [ ]
    }

    avatar.test(delta, visible_files) # tag 2

    assert_equal :green, avatar.lights[-1].colour

    diffs = avatar.tags[was_tag=1].diff(now_tag=2)

    expected =
    {
      'hiker.rb' =>
      [
        { :line => '',           :type => :same,    :number => 1 },
        { :line => 'def answer', :type => :same,    :number => 2 },
        { :type => :section, :index => 0 },
        { :line => '  6 * 9',       :type => :deleted, :number => 3 },
        { :line => '  6 * 7',       :type => :added,   :number => 3 },
        { :line => 'end',        :type => :same,    :number => 4 },
      ],
      'test_hiker.rb' => sameify(visible_files['test_hiker.rb']),
      'cyber-dojo.sh' => sameify(visible_files['cyber-dojo.sh'])
    }

    assert_equal expected['hiker.rb'], diffs['hiker.rb']
    assert_equal expected['test_hiker.rb'], diffs['test_hiker.rb']
    assert_equal expected['cyber-dojo.sh'], diffs['cyber-dojo.sh']

    view = git_diff_view(diffs)

    expected_view = [
      {
        :id => 'id_0',
        :filename => 'cyber-dojo.sh',
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content => '<same>ruby *test*.rb</same><same>&thinsp;</same>',
        :line_numbers => '<same><ln>1</ln></same><same><ln>2</ln></same>'
      },
      {
        :id => 'id_1',
        :filename => 'hiker.rb',
        :section_count => 1,
        :deleted_line_count => 1,
        :added_line_count => 1,
        :content =>
          "<same>&thinsp;</same>" +
          "<same>def answer</same>" +
          "<span id='id_1_section_0'></span>" +
          "<deleted>  6 * 9</deleted>" +
          "<added>  6 * 7</added>" +
          "<same>end</same>",

        :line_numbers =>
          "<same><ln>1</ln></same>" +
          "<same><ln>2</ln></same>" +
          "<deleted><ln>3</ln></deleted>" +
          "<added><ln>3</ln></added>" +
          "<same><ln>4</ln></same>"
      }
    ]

    assert_equal expected_view[0], view[0], '0'
    assert_equal expected_view[1], view[1], '1'
  end

  #-----------------------------------------------

  test 'building git diff view from repo with deleted file' do

    language = @dojo.languages['Ruby-TestUnit']
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

    deleted_filename = 'hiker.rb'
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

    assert_equal :amber, avatar.lights[-1].colour

    diff = avatar.tags[was_tag=1].diff(now_tag=2)
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

    diff = avatar.tags[was_tag=0].diff(now_tag=1)
    diff.keys.each do |filename|
      assert visible_files.keys.include?(filename),
            "visible_files.keys.include?(#{filename})"
    end

    assert_equal visible_files.length, diff.length
  end

end
