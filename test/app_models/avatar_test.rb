#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class AvatarTests < ModelTestBase

  include TimeNow

  test 'path(avatar)' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    assert path_ends_in_slash?(avatar)
    assert path_has_no_adjacent_separators?(avatar)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  test 'attempting to create an Avatar with an invalid name raises RuntimeError' do
    kata = katas[unique_id]
    invalid_name = 'salmon'
    assert !Avatars.names.include?(invalid_name)
    assert_raises(RuntimeError) { kata.avatars[invalid_name] }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar returns kata it was created with" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal kata, avatar.kata
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created its sandbox contains each visible_file" do
    kata = make_kata
    avatar = kata.start_avatar
    kata.language.visible_files.each do |filename,content|
      assert_equal content, avatar.sandbox.dir.read(filename)
    end
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  test 'avatar is not active? when it does not exist' do
    kata = katas[unique_id]
    lion = kata.avatars['lion']
    assert !lion.exists?
    assert !lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar is not active? when it has zero traffic-lights' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    assert_equal [ ], lion.lights
    assert !lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar is active? when it has one traffic-light' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    stub_test(lion,1)
    assert_equal 1, lion.lights.length
    assert lion.active?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is true when dir exists and name is in Avatar.names' do
    kata = katas[unique_id]
    lion = kata.avatars['lion']
    assert !lion.exists?
    lion.dir.make
    assert lion.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'after avatar is started its visible_files are ' +
       ' the language visible_files,' +
       ' the exercse instructions,' +
       ' and empty output' do
    kata = make_kata
    language = kata.language
    avatar = kata.start_avatar
    language.visible_files.each do |filename,content|
      assert avatar.visible_files.keys.include?(filename)
      assert_equal avatar.visible_files[filename], content
    end
    assert avatar.visible_files.keys.include? 'instructions'
    assert avatar.visible_files['instructions'].include? kata.exercise.instructions
    assert avatar.visible_files.keys.include? 'output'
    assert_equal '',avatar.visible_files['output']
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar creation saves' +
          ' each visible_file into avatar/sandbox,' +
          ' and empty avatar/increments.json' do
            
    language = languages['Java-JUnit']    
    exercise = exercises['Fizz_Buzz']
    kata = katas.create_kata(language, exercise)
    avatar = kata.start_avatar
    sandbox = avatar.sandbox
    language.visible_files.each do |filename,content|
      assert_equal content, sandbox.dir.read(filename)
    end
    assert_equal [ ], JSON.parse(avatar.dir.read('increments.json'))
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'after test() output-file is saved in sandbox ' +
       'and output is inserted into the visible_files argument' do         
    kata = make_kata
    avatar = kata.start_avatar
    code_filename = 'hiker.c'
    test_filename = 'hiker.tests.c'
    filenames = kata.language.visible_files.keys
    [code_filename,test_filename].each {|filename| assert filenames.include? filename}
    visible_files = {
      code_filename => 'content for code file',
      test_filename => kata.language.visible_files[test_filename],
      'cyber-dojo.sh' => 'make'
    }
    delta = {
      :changed => [ code_filename ],
      :unchanged => [ test_filename ],
      :deleted => [ ],
      :new => [ ]
    }
    runner.stub_output('hello')
    assert !visible_files.keys.include?('output')    
    avatar.test(delta, visible_files)
    assert visible_files.keys.include?('output')
    output = visible_files['output']
    assert_equal 'hello', output
    assert_equal output, avatar.sandbox.dir.read('output')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save():delta[:changed] files are saved' do
    kata = make_kata
    language = kata.language
    avatar = kata.start_avatar
    sandbox = avatar.sandbox
    code_filename = 'hiker.c'
    test_filename = 'hiker.tests.c'
    filenames = language.visible_files.keys
    [code_filename,test_filename].each {|filename| assert filenames.include? filename }
    visible_files = {
      code_filename => 'changed content for code file',
      test_filename => 'changed content for test file',
      'cyber-dojo.sh' => 'make'
    }
    delta = {
      :changed => [ code_filename, test_filename ],
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }    
    delta[:changed].each do |filename|
      assert_equal language.visible_files[filename], sandbox.dir.read(filename)
      assert_not_equal language.visible_files[filename], visible_files[filename]
    end
    runner.stub_output('')
    avatar.test(delta, visible_files)    
    delta[:changed].each do |filename|
      assert_equal visible_files[filename], sandbox.dir.read(filename)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save():delta[:unchanged] files are not saved' do
    kata = make_kata
    language = kata.language  
    avatar = kata.start_avatar
    sandbox = avatar.sandbox  
    code_filename = 'abc.c'
    test_filename = 'abc.tests.c'
    filenames = language.visible_files.keys
    [code_filename,test_filename].each {|filename| assert !filenames.include?(filename) }
    visible_files = {
      code_filename => 'changed content for code file',
      test_filename => 'changed content for test file',
      'cyber-dojo.sh' => 'make'
    }
    delta = {
      :changed => [ ], 
      :unchanged => [ code_filename, test_filename ],
      :deleted => [ ],
      :new => [ ]
    }  
    runner.stub_output('')
    avatar.test(delta, visible_files)
    delta[:unchanged].each do |filename|
      assert !sandbox.dir.exists?(filename)
    end
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save():delta[:new] files are saved and git added' do
    kata = make_kata
    avatar = kata.start_avatar
    language = kata.language
    sandbox = avatar.sandbox
    new_filename = 'ab.c'
    visible_files = {
      new_filename => 'content for new code file',
    }
    delta = {
      :changed => [ ],
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ new_filename ]
    }

    assert !git_log_include?(avatar.sandbox.path, ['add', "#{new_filename}"])    
    delta[:new].each do |filename|
      assert !sandbox.dir.exists?(filename)
    end           
    
    runner.stub_output('')
    avatar.test(delta, visible_files)
    
    assert git_log_include?(avatar.sandbox.path, ['add', "#{new_filename}"])    
    delta[:new].each do |filename|
      assert sandbox.dir.exists?(filename)
      assert_equal visible_files[filename], sandbox.dir.read(filename)      
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save():delta[:deleted] files are git rm'd" do
    kata = make_kata
    avatar = kata.start_avatar
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs' ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]
    }

    runner.stub_output('')    
    avatar.test(delta, visible_files)

    git_log = git.log[avatar.sandbox.path]
    assert git_log.include?([ 'rm', 'wibble.cs' ]), git_log.inspect
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tag.diff' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    fake_three_tests(lion)
    manifest = JSON.unparse({
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#ifndef HIKER_INCLUDED_H\n#endif',
      'output' => 'unterminated conditional directive'
    })
    filename = 'manifest.json'
    git.spy(lion.dir.path,'show',"#{3}:#{filename}",manifest)
    stub_diff = [
      "diff --git a/sandbox/hiker.h b/sandbox/hiker.h",
      "index e69de29..f28d463 100644",
      "--- a/sandbox/hiker.h",
      "+++ b/sandbox/hiker.h",
      "@@ -1 +1,2 @@",
      "-#ifndef HIKER_INCLUDED",
      "\\ No newline at end of file",
      "+#ifndef HIKER_INCLUDED_H",
      "+#endif",
      "\\ No newline at end of file"
    ].join("\n")
    git.spy(lion.dir.path,
      'diff',
      '--ignore-space-at-eol --find-copies-harder 2 3 sandbox',
      stub_diff)

    tags = lion.tags
    actual = lion.diff(2,3) #tags[2].diff(3)
    expected =
    {
      "hiker.h" =>
      [
        { :type => :section, :index => 0 },
        { :type => :deleted, :line => "#ifndef HIKER_INCLUDED", :number => 1 },
        { :type => :added,   :line => "#ifndef HIKER_INCLUDED_H", :number => 1 },
        { :type => :added,   :line => "#endif", :number => 2 }
      ],
      "hiker.c" =>
      [
        { :line => "#include \"hiker.h\"", :type => :same, :number => 1 }
      ],
      "output" =>
      [
        { :line => "unterminated conditional directive", :type => :same, :number => 1 }
      ]
    }
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - -

  def fake_three_tests(avatar)
    incs =
    [
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 55, 7],
        'number' => 3
      }
    ]
    avatar.dir.write('increments.json', incs)
  end
  
  #- - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - -

=begin
  test 'visible_files' do
    kata = make_kata
    visible_files = kata.start_avatar(['lion']).visible_files
    assert visible_files['wibble.hpp'].start_with?('#include <iostream>')
    assert visible_files['wibble.cpp'].start_with?('#include "wibble.hpp"')
    assert visible_files['instructions'].start_with?('Note: The initial code')
    assert_equal '', visible_files['output']
  end
=end
  
    #- - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "avatar (json) creation sets up initial git repo of visible files " +
        "but support_files are not in git repo" do
    @dojo = Dojo.new('spied/','json')
    @kata = @dojo[@id]
    visible_files = {
      'name' => 'content for name'
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    kata_manifest_spy_read(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar

    git_log = @git.log[avatar.path]
    assert_equal [ 'init', '--quiet'], git_log[0]
    add1_index = git_log.index([ 'add', 'increments.json' ])
    assert_not_nil add1_index
    add2_index = git_log.index([ 'add', 'manifest.json'])
    assert_not_nil add2_index
    commit1_index = git_log.index([ 'commit', "-a -m '0' --quiet" ])
    assert_not_nil commit1_index
    commit2_index = git_log.index([ 'commit', "-m '0' 0 HEAD" ])
    assert_not_nil commit2_index

    assert add1_index < commit1_index
    assert add1_index < commit2_index
    assert add2_index < commit1_index
    assert add2_index < commit2_index

    assert_equal [
      [ 'add', 'name']
    ], @git.log[avatar.sandbox.path], @git.log.inspect

    assert avatar.dir.log.include?([ 'write', 'manifest.json', JSON.unparse(visible_files)]), avatar.dir.log.inspect
    assert avatar.dir.log.include?([ 'write', 'increments.json', JSON.unparse([ ])]), avatar.dir.log.inspect
    assert kata.dir.log.include?([ 'write','manifest.json', JSON.unparse(manifest)]), kata.dir.log.inspect
    assert kata.dir.log.include?([ 'read','manifest.json', JSON.unparse(manifest)]), kata.dir.log.inspect
  end
=end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "avatar's tag 0 repo contains an empty output file only when kata-manifest does" do
    @dojo = Dojo.new('spied/','json')
    @kata = @dojo[@id]
    visible_files = {
      'name' => 'content for name',
      'output' => ''
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    kata_manifest_spy_read(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('output'),
          "visible_files.keys.include?('output')"
    assert_equal "", visible_files['output']
  end
=end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "after first test() traffic_lights contains one traffic-light " +
        "which does not contain output" do
    @dojo = Dojo.new('spied/', 'json')
    @kata = @dojo[@id]
    visible_files = {
      'untitled.c' => 'content for visible file',
      'cyber-dojo.sh' => 'make',
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    kata_manifest_spy_read(manifest)
    kata = @dojo.create_kata(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({
        "visible_files" => visible_files,
        "unit_test_framework" => "cassert"
      }))
    avatar = @kata.start_avatar
    avatar.sandbox.dir.spy_write('untitled.c', 'content for visible file')
    avatar.sandbox.dir.spy_write('cyber-dojo.sh', 'make')
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'cyber-dojo.sh' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]
    }
    avatar.sandbox.write(delta, avatar.visible_files)
    output = avatar.sandbox.test(timeout=15)
    visible_files['output'] = output
    avatar.save_manifest(visible_files)

    traffic_light = OutputParser::parse(@kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 1, traffic_lights.length
    assert_nil traffic_lights.last[:run_tests_output]
    assert_nil traffic_lights.last[:output]
  end
=end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "one more traffic light each test() call" do
    @dojo = Dojo.new('spied/', 'json')
    @kata = @dojo[@id]
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name,
      :visible_files => [ ]
    }
    kata_manifest_spy_read(manifest)
    @kata = @dojo.create_kata(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({
        "visible_files" => [ ],
        "unit_test_framework" => "cassert"
      }))
    avatar = @kata.start_avatar
    output = 'stubbed'
    traffic_light = OutputParser::parse('cassert', output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 1, traffic_lights.length
    traffic_light = OutputParser::parse('cassert', output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 2, traffic_lights.length
  end
=end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "locked_read with tag" do
    @dojo = Dojo.new('spied/', 'json')
    @kata = @dojo[@id]
    avatar = @kata['lion']
    output = avatar.visible_files(tag=4)
    assert @git.log[avatar.path].include?(
      [
       'show',
       '4:manifest.rb'
      ])
  end
=end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  def kata_manifest_spy_read(manifest)
    @paas.dir(@kata).spy_read('manifest.json', JSON.unparse(manifest))
  end
=end

  def git_log_include?(path,find)
    git.log[path].any?{|entry| entry == find}    
  end  

end
