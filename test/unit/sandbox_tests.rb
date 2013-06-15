require File.dirname(__FILE__) + '/../test_helper'

class SandboxTests < ActionController::TestCase

  def setup
    @id = 'ABCDE12345'
    @avatar_name = 'hippo'
    @sandbox = Sandbox.new(root_dir, @id, @avatar_name)
  end
  
  def teardown
    if File.exists? @sandbox.dir
      `rm -rf #{root_dir + '/sandboxes/AB'}`
    end
    @sandbox = nil
  end

  # It seems file.atime/ctime/mtime only store the time to the second
  # That is not fine enough for the test...
  #
  #test "after running tests for second time with no change in any file then no file time-stamps are updated" do    
  #  language = Language.new(root_dir, 'Ruby-installed-and-working')        
  #  visible_files = language.visible_files
  #  
  #  output = @sandbox.run(language, visible_files)
  #  before = { }
  #  visible_files.each do |filename,_|
  #    ts = File.new(@sandbox.dir + filename).atime
  #    before[filename] = ts.to_s
  #  end
  #  output = @sandbox.run(language, visible_files)
  #  after = { }
  #  visible_files.each do |filename,_|
  #    ts = File.new(@sandbox.dir + filename).atime
  #    after[filename] = ts.to_s
  #  end
  #  visible_files.each do |filename,_|
  #    p "#{before[filename]} --- #{after[filename]}"
  #    assert_equal before[filename], after[filename]
  #  end
  #end
    
    # avatar.git_commit_tag() looks like it will also
    # be considerably simplified
    # why do I do "git add filename" in a loop
    # Surely it would be ok to do "git add ."
    
    # Then avatar.initialize
    # def initialize(kata, name) 
    #    @kata = kata
    #    @name = name
    #    if !File.exists? dir
    #      Dir::mkdir(dir)
    #      Files::file_write(pathed(Manifest_filename), @kata.visible_files)
    #      Files::file_write(pathed(Increments_filename), [ ])
    #      command = "git init --quiet;" +
    #                "git add '#{Manifest_filename}';" +
    #                "git add '#{Increments_filename}';"    
    #
    # this can change to...
    #
    # def initialize(kata, name) 
    #    @kata = kata
    #    @name = name
    #    if !File.exists? dir
    #      Dir::mkdir(dir)
    #      Dir::mkdir(dir + 'sandbox')
    #      Files::file_write(pathed(Manifest_filename), @kata.visible_files)
    #      Files::file_write(pathed(Increments_filename), [ ])
    #      command = "git init --quiet;" +
    #                "git add .;"
    #
    # Also avatar.git_commit_tag() looks like this...
    #
    #  def git_commit_tag(visible_files, tag)
    #    system("rm -rf #{sandbox}")
    #    Dir::mkdir(sandbox)
    #    command = ""
    #    visible_files.each do |filename,content|
    #      pathed_filename = sandbox + '/' + filename
    #      Folders::make_folder(pathed_filename)      
    #      File.open(pathed_filename, 'w') { |file| file.write content }      
    #      command += "git add '#{pathed_filename}';"
    #    end
    #    command += "git commit -a -m '#{tag}' --quiet;"
    #    command += "git tag -m '#{tag}' #{tag} HEAD;"
    #    system(cd_dir(command))
    #  end
    #
    # This can become...
    #
    #  def git_commit_tag(visible_files, tag)
    #    ...
    #    command += "git add .;"
    #    command += "git commit -a -m '#{tag}' --quiet;"
    #    command += "git tag -m '#{tag}' #{tag} HEAD;"
    #    system(cd_dir(command))
    #  end
    # Either way is better than adding files individually
    # because it captures any files that might have been created
    # (such as .txt approval files).
    #
    #
    # Note also that I should not be doing the link_files() calls
    # every time. That should happen once at the creation of the avatar
    # object. It does raise the question of what happens if, in the
    # browser, someone tries to create a file with the same name as
    # a support/hidden file. The answer is they can't. I check for that
    # in javascript.


  test "sandbox.make_dir creates inner-outer-avatar off root_dir-sandboxes" do
    @sandbox.make_dir
    dir = root_dir + '/katas/' + @id[0..1] + '/' +@id[2..-1] + '/' + @avatar_name + '/' + 'sandbox' + '/'
    assert_equal dir, @sandbox.dir
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end
 
  test "saving a file with a folder creates the subfolder and the file in it" do
    filename = 'f1/f2/wibble.txt'
    content = 'Hello world'
    @sandbox.save_file(filename, content)
    pathed_filename = @sandbox.dir + '/' + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal content, IO.read(pathed_filename)          
  end
  
  test "after run() a file called output is saved in sandbox and contains the output" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    @sandbox.make_dir
    output = @sandbox.run(language, visible_files)    
    output_filename = @sandbox.dir + 'output'
    assert File.exists?(output_filename),
          "File.exists?(#{output_filename})"
    assert_equal output, IO.read(output_filename)          
  end
  
  test "visible and hidden files are copied to sandbox and output is generated" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files

    @sandbox.make_dir
    output = @sandbox.inner_run(language, visible_files)
    assert File.exists?(@sandbox.dir), "sandbox dir created"
    
    visible_files.each do |filename,content|
      assert File.exists?(@sandbox.dir + '/' + filename),
            "File.exists?(#{@sandbox.dir}/#{filename})"
    end
    
    # TODO: there are no hidden files so this does not test anything
    language.hidden_filenames.each do |filename|
      assert File.exists?(@sandbox.dir + '/' + filename),
            "File.exists?(#{@sandbox.dir}/#{filename})"
    end
    
    assert_match output, /\<54\> expected but was/
  end    
      
  test "sandbox dir is not deleted after run" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')        
    visible_files = language.visible_files
    output = @sandbox.run(language, visible_files)
    assert_not_nil output, "output != nil"
    assert output.class == String, "output.class == String"
    assert_match output, /\<54\> expected but was/
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end

  #TODO: do this with an 'echo xx > received.txt' command in the cyber-dojo.sh file
  #test "new text files created in test run are added to visible_files" do
  #  language = Language.new(root_dir, 'ApprovalTests-Java')
  #  visible_files = language.visible_files
  #  output = @sandbox.run(language, visible_files)
  #  assert visible_files.keys.include?("UntitledTest.hitch_hiker.received.txt"), visible_files.to_s
  #  assert_match visible_files["UntitledTest.hitch_hiker.received.txt"], /42/
  #end

  test "missing text files are removed from visible_files" do
    visible_files = { }
    visible_files["foo.txt"] = "bar"
    temp_dir = Dir.mktmpdir # empty dir, does not contain foo.txt
    output = @sandbox.update_visible_files_with_text_files_created_and_deleted_in_test_run(temp_dir, visible_files)
    assert (not visible_files.keys.include?("foo.txt")), visible_files.to_s
  end

  test "text from multi-line files is saved in visible_files" do
    visible_files = {}
    temp_dir = Dir.mktmpdir
    f = File.open(Pathname.new(temp_dir).join("foo.txt"), "w")
    f.write("a multiline\nstring\n")
    f.close()
    output = @sandbox.update_visible_files_with_text_files_created_and_deleted_in_test_run(temp_dir, visible_files)
    assert (visible_files.keys.include?("foo.txt")), visible_files.to_s
    assert_match visible_files["foo.txt"], "a multiline\nstring\n", visible_files.to_s
  end

  test "text from windows files is saved with unix line endings" do
    visible_files = {}
    temp_dir = Dir.mktmpdir
    f = File.open(Pathname.new(temp_dir).join("bar.txt"), "w")
    f.write("a multiline\r\nstring\r\n")
    f.close()
    output = @sandbox.update_visible_files_with_text_files_created_and_deleted_in_test_run(temp_dir, visible_files)
    assert_match visible_files["bar.txt"], "a multiline\nstring\n", visible_files.to_s
  end

  test "updated text files are updated in visible_files" do
    visible_files = {"baz.txt" => "foo"}
    temp_dir = Dir.mktmpdir
    f = File.open(Pathname.new(temp_dir).join("baz.txt"), "w")
    f.write("baz updated")
    f.close()
    output = @sandbox.update_visible_files_with_text_files_created_and_deleted_in_test_run(temp_dir, visible_files)
    assert_match visible_files["baz.txt"], "baz updated", visible_files.to_s
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "save file for non executable file" do
    @sandbox.make_dir    
    check_save_file('file.a', 'content', 'content', false)
  end
  
  test "save file for executable file" do
    @sandbox.make_dir    
    check_save_file('file.sh', 'ls', 'ls', true)
  end
  
  test "save file for makefile converts all leading whitespace on a line to a single tab" do
    @sandbox.make_dir    
    check_save_makefile("            abc", "\tabc")
    check_save_makefile("        abc", "\tabc")
    check_save_makefile("    abc", "\tabc")
    check_save_makefile("\tabc", "\tabc")
  end
  
  test "save file for Makefile converts all leading whitespace on a line to a single tab" do
    @sandbox.make_dir    
    check_save_file('Makefile', "            abc", "\tabc", false)
    check_save_file('Makefile', "        abc", "\tabc", false)
    check_save_file('Makefile', "    abc", "\tabc", false)
    check_save_file('Makefile', "\tabc", "\tabc", false)
  end
  
  test "save file for makefile converts all leading whitespace to single tab for all lines in any line format" do
    @sandbox.make_dir    
    check_save_makefile("123\n456", "123\n456")
    check_save_makefile("123\r\n456", "123\n456")
    
    check_save_makefile("    123\n456", "\t123\n456")
    check_save_makefile("    123\r\n456", "\t123\n456")
    
    check_save_makefile("123\n    456", "123\n\t456")
    check_save_makefile("123\r\n    456", "123\n\t456")
    
    check_save_makefile("    123\n   456", "\t123\n\t456")
    check_save_makefile("    123\r\n   456", "\t123\n\t456")
    
    check_save_makefile("    123\n456\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\r\n456\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\n456\r\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\r\n456\r\n   789", "\t123\n456\n\t789")    
  end

  def check_save_makefile(content, expected_content)    
    check_save_file('makefile', content, expected_content, false)
  end
      
  def check_save_file(filename, content, expected_content, executable)
    @sandbox.save_file(filename, content)
    pathed_filename = @sandbox.dir + '/' + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            "File.executable?(pathed_filename)"
  end
      
end

