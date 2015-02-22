#!/usr/bin/env ruby

require_relative 'integration_test_base'

class GitDiffViewTests < IntegrationTestBase

  include GitDiff

  test 'building diff view from git repo with modified file' do

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

    visible_files['hiker.c'].sub!('6 * 9','6 * 7')
    delta = {
      :changed => [ 'hiker.c' ],
      :unchanged => visible_files.keys - [ 'hiker.c' ],
      :deleted => [ ],
      :new => [ ]
    }

    avatar.test(delta, visible_files) # tag 2

    assert_equal :green, avatar.lights[-1].colour

    diffs = avatar.tags[was_tag=1].diff(now_tag=2)

    expected =
    {
      'hiker.c' =>
      [
        { :line => "#include \"hiker.h\"\r", :type => :same,    :number => 1 },
        { :line => "\r",                     :type => :same,    :number => 2 },
        { :line => "int answer(void)\r",     :type => :same,    :number => 3 },
        { :line => "{\r",                    :type => :same,    :number => 4 },
        {                                    :type => :section, :index => 0 },
        { :line => "    return 6 * 9;\r",    :type => :deleted, :number => 5 },
        { :line => "    return 6 * 7;\r",    :type => :added,   :number => 5 },
        { :line => "}\r",                    :type => :same,    :number => 6 },
      ],
      'hiker.tests.c'  => sameify(visible_files['hiker.tests.c']),
      'cyber-dojo.sh' => sameify(visible_files['cyber-dojo.sh'])
    }

    assert_equal expected['hiker.c'], diffs['hiker.c']

    assert_equal expected['hiker.tests.c'], diffs['hiker.tests.c']
    assert_equal expected['cyber-dojo.sh'], diffs['cyber-dojo.sh']

    view = git_diff_view(diffs)

    expected_view = [
      {
        :id => 'id_0',
        :filename => 'cyber-dojo.sh',
        :section_count => 0,
        :deleted_line_count => 0,
        :added_line_count => 0,
        :content => '<same>make</same>',
        :line_numbers => '<same><ln>1</ln></same>'
      },
      {
        :id => 'id_1',
        :filename => 'hiker.c',
        :section_count => 1,
        :deleted_line_count => 1,
        :added_line_count => 1,
        :content =>
          "<same>#include &quot;hiker.h&quot;\r</same>" +
          "<same>\r</same>" +
          "<same>int answer(void)\r</same>" +
          "<same>{\r</same>" +
          "<span id='id_1_section_0'></span>" +
          "<deleted>    return 6 * 9;\r</deleted>" +
            "<added>    return 6 * 7;\r</added>" +
          "<same>}\r</same>",

        :line_numbers =>
          "<same><ln>1</ln></same>" +
          "<same><ln>2</ln></same>" +
          "<same><ln>3</ln></same>" +
          "<same><ln>4</ln></same>" +
          "<deleted><ln>5</ln></deleted>" +
          "<added><ln>5</ln></added>" +
          "<same><ln>6</ln></same>"
      }
    ]

    assert_equal expected_view[0], view[0], '0'
    assert_equal expected_view[1], view[1], '1'
  end

  #-----------------------------------------------

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
