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
   
  test "after run_tests() a file called output is saved in sandbox and contains the output" do
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    visible_files = language.visible_files
    output = @sandbox.run_tests(language, visible_files)    
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

end

