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
  
  test "after run_tests() a file called output is saved in sandbox" +
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
    output = sandbox.run_tests(visible_files)
    assert !visible_files.keys.include?('output')
    assert output.class == String, "output.class == String"
    assert_equal "amber", output
    assert_equal ['output',"amber".inspect], @stub_file.write_log[sandbox.dir].last    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "run_tests() linked hidden files into sandbox dir" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.c' => 'content for code file',
      'untitled.test.c' => 'content for test file',
      'cyber-dojo.sh' => 'make'
    }
    language_name = 'C'
    language = Language.new(root_dir, language_name)    
    @stub_file.read=({
      :dir => kata.dir,
      :filename => 'manifest.rb',
      :content => {
        :language => language_name
      }.inspect
    })
    hidden_filename = 'secret.h'
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => {
        :hidden_filenames => [ hidden_filename ],
        :support_filenames => [ ]
      }.inspect      
    })
    sandbox.run_tests(visible_files)    
    assert @stub_file.symlink_log.include?(
      [ 'symlink',
         language.dir + @stub_file.separator + hidden_filename,
         sandbox.dir + @stub_file.separator + hidden_filename
      ]
    )
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "run_tests() links support files into sandbox dir" do
    id = '145ED23A2F'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'frog')
    sandbox = avatar.sandbox    
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    language_name = 'C#'
    language = Language.new(root_dir, language_name)    
    @stub_file.read=({
      :dir => kata.dir,
      :filename => 'manifest.rb',
      :content => {
        :language => language_name
      }.inspect
    })
    support_filename = 'secret.dll'
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => {
        :hidden_filenames => [ ],
        :support_filenames => [ support_filename ]
      }.inspect      
    })
    sandbox.run_tests(visible_files)    
    assert @stub_file.symlink_log.include?(
      [ 'symlink',
         language.dir + @stub_file.separator + support_filename,
         sandbox.dir + @stub_file.separator + support_filename
      ]
    )    
  end
  
end

