require File.dirname(__FILE__) + '/../coverage_test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class SandboxTests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    @stub_git = StubDiskGit.new
    @stub_task = StubTimeBoxedTask.new
    Thread.current[:file] = @stub_file
    Thread.current[:git] = @stub_git
    Thread.current[:task] = @stub_task
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
    Thread.current[:task] = nil
  end

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not end in slash" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'hippo')
    sandbox = avatar.sandbox
    assert !sandbox.dir.end_with?(@stub_file.separator),
          "!#{sandbox.dir}.end_with?(#{@stub_file.separator})"       
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "dir does not have doubled separator" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'hippo')
    sandbox = avatar.sandbox    
    doubled_separator = @stub_file.separator * 2
    assert_equal 0, sandbox.dir.scan(doubled_separator).length    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "dir is not created until file is saved" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'hippo')
    sandbox = avatar.sandbox    
    assert !@stub_file.exists?(sandbox.dir),
          "!@stub_file.exists?(#{sandbox.dir})"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save(visible_files) creates dir and saves files" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'hippo')
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.rb' => 'content for code file',
      'untitled_test.rb' => 'content for test file'
    }    
    assert_equal nil, @stub_file.write_log[sandbox.dir]    
    sandbox.save(visible_files)    
    assert_equal [
      [ 'untitled.rb', 'content for code file'.inspect ],
      [ 'untitled_test.rb', 'content for test file'.inspect ]
    ], @stub_file.write_log[sandbox.dir]    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "after run_tests() a file called output is saved in sandbox " +
         "and an output file is not inserted into the visible_files argument" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    animal_name = 'frog'
    avatar = Avatar.new(kata, animal_name)
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.c' => 'content for code file',
      'untitled.test.c' => 'content for test file',
      'cyber-dojo.sh' => 'make'
    }
    # run-tests also pulls
    # avatar.kata.language.support_filenames
    # avatar.kata.language.hidden_filenames
    language_name = 'C'
    language = Language.new(root_dir, language_name)    
    @stub_file.read=({
      :dir => kata.dir,
      :filename => 'manifest.rb',
      :content => {
        :language => language_name
      }.inspect
    })    
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => {
        :hidden_filenames => [ ],
        :support_filenames => [ ],
      }.inspect      
    })
    assert !visible_files.keys.include?('output')    
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'untitled.test.c' ],
      :deleted => [ ],
      :new => [ ]
    }
    output = sandbox.test(delta, visible_files)    
    assert !visible_files.keys.include?('output')
    assert output.class == String, "output.class == String"
    assert_equal "amber", output
    assert_equal ['output',"amber".inspect], @stub_file.write_log[sandbox.dir].last    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:changed] files are saved" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs', 'untitled.test.cs'  ],
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }
    sandbox.test(delta, visible_files)
    log = @stub_file.write_log[sandbox.dir]
    saved_files = filenames_in(log)    
    assert_equal ['output', 'untitled.cs', 'untitled.test.cs'], saved_files.sort    
    assert log.include?(
      ['untitled.cs', 'content for code file'.inspect ]                                                 
    ), log.inspect
    assert log.include?(
      ['untitled.test.cs', 'content for test file'.inspect ]                                                 
    ), log.inspect
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "test():delta[:unchanged] files are not saved" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs' ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ ],
      :new => [ ]
    }
    sandbox.test(delta, visible_files)
    log = @stub_file.write_log[sandbox.dir]
    saved_files = filenames_in(log)
    assert !saved_files.include?('cyber-dojo.sh'), saved_files.inspect
    assert !saved_files.include?('untitled.test.cs'), saved_files.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "test():delta[:new] files are saved and git added" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
    visible_files = {
      'wibble.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ ],
      :new => [ 'wibble.cs' ]
    }
    sandbox.test(delta, visible_files)
    write_log = @stub_file.write_log[sandbox.dir]
    saved_files = filenames_in(write_log)
    assert saved_files.include?('wibble.cs'), saved_files.inspect
    
    git_log = @stub_git.log[sandbox.dir]
    assert git_log.include?([ 'add', 'wibble.cs' ]), git_log.inspect
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      
  test "test():delta[:deleted] files are git rm'd" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
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
    sandbox.test(delta, visible_files)
    write_log = @stub_file.write_log[sandbox.dir]
    saved_files = filenames_in(write_log)
    assert !saved_files.include?('wibble.cs'), saved_files.inspect
    
    git_log = @stub_git.log[sandbox.dir]
    assert git_log.include?([ 'rm', 'wibble.cs' ]), git_log.inspect
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def content_for_untitled_java
    [
      "public class Untitled { ",
      "    public static int answer() { ",
      "        return 42;",
      "    }",
      "}"
    ].join("\n")
  end
  
  def content_for_untitled_test_java
    [
      "import org.junit.*;",
      "import static org.junit.Assert.*;",
      "",
      "public class UntitledTest {",
      "",    
      "    @Test",
      "    public void hitch_hiker() {",
      "        int expected = 6 * 7;",
      "        int actual = Untitled.answer();",
      "        assertEquals(expected, actual);",
      "    }",
      "}"
    ].join("\n")
  end
  
  def content_for_cyber_dojo_sh
    [
      "rm *.class",
      "javac -cp .:./junit-4.11.jar *.java ",
      "if [ $? -eq 0 ]; then",
      "  java -cp .:./junit-4.11.jar org.junit.runner.JUnitCore `ls -1 *Test*.class | grep -v '\\$' | sed 's/\(.*\)\..*/\1/'`",
      "fi"
    ].join("\n")
  end
  
  test "defect-driven: filename containing space is not accidentally retained" do
    # retained means stays in the 
    teardown
    kata = make_kata('Java-JUnit', exercise='Dummy')
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.create(kata, avatar_name)
    
    id = kata.id
    kata = Kata.new(root_dir, id)
    sandbox = avatar.sandbox
    
    visible_files = {
      'Untitled.java' => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh' => content_for_cyber_dojo_sh
    }
    delta = {
      :unchanged => [ ],
      :changed => [ 'cyber-dojo.sh', 'UntitledTest.java', 'Untitled.java' ],
      :deleted => [ ],
      :new => [ ]
    }
    output = sandbox.test(delta, visible_files)    
    traffic_light = CodeOutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    assert_equal :green, traffic_light[:colour]
    
    visible_files = {
      'Untitled .java' => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh' => content_for_cyber_dojo_sh
    }
    delta = {
      :unchanged => [ 'cyber-dojo.sh', 'UntitledTest.java' ],
      :changed => [ ],
      :deleted => [ 'Untitled.java' ],
      :new => [ 'Untitled .java' ]
    }
    output = sandbox.test(delta, visible_files)
    avatar.save_run_tests(visible_files, traffic_light)      
    traffic_light = CodeOutputParser::parse('junit', output)
    assert_equal :amber, traffic_light[:colour]
    
    # put it back the way it was
    visible_files = {
      'Untitled.java' => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh' => content_for_cyber_dojo_sh
    }
    delta = {
      :changed => [ ],
      :unchanged => [ 'cyber-dojo.sh', 'UntitledTest.java', 'Untitled.java' ],
      :deleted => [ 'Untitled .java' ],
      :new => [ 'Untitled.java' ]
    }
    output = sandbox.test(delta, visible_files)    
    traffic_light = CodeOutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    # if the file whose name contained a space has been retained
    # this will be :amber instead of :green
    assert_equal :green, traffic_light[:colour], id + ":" + avatar_name
    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def filenames_in(log)
    log.collect{ |entry| entry.first }
  end
  
end

