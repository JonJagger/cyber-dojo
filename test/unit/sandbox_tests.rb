require File.dirname(__FILE__) + '/../test_helper'

class SandboxTests < ActionController::TestCase

  def language
    'Ruby-installed-and-working'    
  end

  def setup
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'hippo')
    @sandbox = Sandbox.new(avatar)
  end
  
  def teardown
    `rm -rf #{@sandbox.dir}`
    @sandbox = nil
  end

  test "sandbox creates inner-outer-avatar off root_dir-sandboxes" do
    dir = @sandbox.dir
    assert_equal dir, @sandbox.dir
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end
   
  test "after run() a file called output is saved in sandbox and contains the output" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    output = @sandbox.run(language, visible_files)    
    output_filename = @sandbox.dir + 'output'
    assert File.exists?(output_filename),
          "File.exists?(#{output_filename})"
    assert_equal output, IO.read(output_filename)          
  end
  
  test "visible and hidden files are copied to sandbox and output is generated" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
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

  test "new text files created in test run are added to visible_files" do
    # do this in a way that does not assume approval is actuall installed!
    language = Language.new(root_dir, 'Ruby-installed-and-working')        
    visible_files = language.visible_files
    content = '42'
    new_text_filename = 'wibble.txt'
    visible_files['cyber-dojo.sh'] = "echo '#{content}' > #{new_text_filename}"
    assert !visible_files.keys.include?(new_text_filename)
    output = @sandbox.run(language, visible_files)
    assert visible_files.keys.include?(new_text_filename)
    assert_equal content+"\n", visible_files[new_text_filename] 
  end

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

end

