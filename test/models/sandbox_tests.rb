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

  test "sandbox dir is created" do
    dir = @sandbox.dir
    assert_equal dir, @sandbox.dir
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end
   
  test "after run_tests() a file called output is saved in sandbox and contains the output" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    output = @sandbox.run_tests(language, visible_files)    
    output_filename = @sandbox.dir + '/' + 'output'
    assert File.exists?(output_filename),
          "File.exists?(#{output_filename})"
    assert_equal output, IO.read(output_filename)          
  end
  
  test "visible and hidden files are copied to sandbox and output is generated" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    output = @sandbox.run_tests(language, visible_files)
    
    visible_files.each do |filename,content|
      pathed_filename = @sandbox.dir + '/' + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"
    end
    
    # TODO: there are no hidden files so this does not test anything
    language.hidden_filenames.each do |filename|
      assert File.exists?(@sandbox.dir + '/' + filename),
            "File.exists?(#{@sandbox.dir}/#{filename})"
    end
    
    assert_match output, /\<54\> expected but was/
  end    
      
  test "sandbox dir is not deleted after run_tests()" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')        
    visible_files = language.visible_files
    output = @sandbox.run_tests(language, visible_files)
    assert_not_nil output, "output != nil"
    assert output.class == String, "output.class == String"
    assert_match output, /\<54\> expected but was/
    assert File.exists?(@sandbox.dir),
          "File.exists?(#{@sandbox.dir})"
  end

=begin
  test "support files are linked into sandbox dir" do
    teardown
    language = Language.new(root_dir, 'Java-Approval')
    assert language.support_filenames.length > 0
    assert !language.dir.end_with?('/'),
          "!#{language.dir}.end_with?('/')"
    
    kata = make_kata('Java-Approval')
    avatar = Avatar.new(kata, 'hippo')
    @sandbox = Sandbox.new(avatar)
    assert !@sandbox.dir.end_with?('/'),
          "!#{@sandbox.dir}.end_with?('/')"    
    
    language.support_filenames.each do |filename|
      pathed_filename = @sandbox.dir + '/' + filename
      assert_equal 0, pathed_filename.scan('//').length
      assert !File.exists?(pathed_filename),
            "!File.exists?(#{pathed_filename})"
    end
    
    @sandbox.link_files(language.dir, language.support_filenames)
    
    language.support_filenames.each do |filename|
      pathed_filename = @sandbox.dir + '/' + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"
      # and somehow check it is an linked file
    end    
  end
=end

end

