require File.dirname(__FILE__) + '/../test_helper'

class SandboxTests < ActionController::TestCase

  def setup
    kata = make_kata('Ruby-installed-and-working')
    avatar = Avatar.create(kata, 'hippo')
    @sandbox = Sandbox.new(avatar)
  end
  
  def teardown
    `rm -rf #{@sandbox.dir}`
    @sandbox = nil
  end
  
  test "dir does not end in slash" do
    assert !@sandbox.dir.end_with?(File::SEPARATOR),
          "!#{@sandbox.dir}.end_with?(#{File::SEPARATOR})"    
  end
  
  test "dir does not have doubled separator" do
    doubled_separator = File::SEPARATOR + File::SEPARATOR
    assert_equal 0, @sandbox.dir.scan(doubled_separator).length    
  end
    
  test "dir is created" do
    dir = @sandbox.dir
    assert_equal dir, @sandbox.dir
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end
   
  test "after run_tests() a file called output is saved in sandbox and contains the output" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    output = @sandbox.run_tests(visible_files)
    assert_not_nil output, "output != nil"
    assert output.class == String, "output.class == String"    
    assert_match output, /\<54\> expected but was/
    
    output_filename = @sandbox.dir + File::SEPARATOR + 'output'
    assert File.exists?(output_filename),
          "File.exists?(#{output_filename})"
    assert_equal output, IO.read(output_filename)          
  end
  
  test "visible and hidden files are copied to sandbox" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    @sandbox.run_tests(visible_files)
    
    visible_files.each do |filename,content|
      pathed_filename = @sandbox.dir + File::SEPARATOR + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"
    end
  end
  
  test "hidden files are copied to sandbox" do  
    # TODO: there are no hidden files for this language so this does not test anything
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    @sandbox.run_tests(visible_files)
    
    language.hidden_filenames.each do |filename|
      pathed_filename = @sandbox.dir + File::SEPARATOR + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"
    end
    
  end    
      
  test "dir is not deleted after run_tests()" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')        
    visible_files = language.visible_files
    @sandbox.run_tests(visible_files)
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end

  test "support files are linked into sandbox dir" do
    teardown
    language = Language.new(root_dir, 'Java-Approval')
    assert language.support_filenames.length > 0
    
    kata = make_kata('Java-Approval', 'Yahtzee', Uuid.new.to_s)
    avatar = Avatar.create(kata, 'hippo')
    @sandbox = avatar.sandbox

    assert Dir.exists?(@sandbox.dir),
          "Dir.exists?(#{@sandbox.dir})"
              
    language.support_filenames.each do |filename|
      pathed_filename = @sandbox.dir + File::SEPARATOR + filename
      assert !File.exists?(pathed_filename),
            "!File.exists?(#{pathed_filename})"
    end
    
    @sandbox.link_files(language, language.support_filenames)
    
    language.support_filenames.each do |filename|
      pathed_filename = @sandbox.dir + File::SEPARATOR + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"
      assert File.symlink?(pathed_filename),
            "File.symlink?(#{pathed_filename})"
    end    
  end

end

