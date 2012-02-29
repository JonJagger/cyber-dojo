require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/code_runner_tests.rb

class LanguageFileset
  
  def initialize(language_dir)
    @language_dir = language_dir
  end
     
  def visible_files
    seen = { }
    manifest[:visible_filenames].each do |filename|
      seen[filename] = IO.read("#{@language_dir}/#{filename}")
    end
    seen
  end
        
  def hidden_filenames
    manifest[:hidden_filenames] || [ ]
  end
  
  #unit_test_framework
  #tab_size
  
private

  def manifest
    @manifest ||= eval IO.read(@language_dir + '/manifest.rb')
  end
  
end


class CodeRunner

  def self.run(sandbox_dir, language_dir, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # visible_files  are the code files from the browser (or test)
    # sandbox_dir    is the dir where the compile/run is to take place
    # language_dir   is the dir of the language associated with
    #                the visible_files, which may provide hidden_files
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Dir.mkdir sandbox_dir
    inner_run(sandbox_dir, language_dir, visible_files)
    system("rm -rf #{sandbox_dir}")
  end
  
  def self.inner_run(sandbox_dir, language_dir, visible_files)
    visible_files.each do |filename,content|
      save_file(sandbox_dir, filename, content)
    end
    command = ''
    fileset = LanguageFileset.new(language_dir)
    fileset.hidden_filenames.each do |hidden_filename|
      command += "ln '#{language_dir}/#{hidden_filename}' '#{sandbox_dir}/#{hidden_filename}';"
    end
    system(command)
    
    command  = "cd '#{sandbox_dir}';" +
               "./cyberdojo.sh"
    max_run_tests_duration = 10
    output = Files::popen_read(command, max_run_tests_duration)
    output
  end

  def self.save_file(dir, filename, content)
    path = dir + '/' + filename
    # No need to lock when writing these files.
    # They are write-once-only
    File.open(path, 'w') do |fd|
      fd.write(makefile_filter(filename, content))
    end
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

  def self.makefile_filter(name, content)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    # makefiles are tab sensitive...
    # The CyberDojo editor intercepts tab keys and replaces them with spaces.
    # Hence this special filter, just for makefiles to convert leading spaces 
    # back to a tab character.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    if name.downcase == 'makefile'
      lines = [ ]
      newline = Regexp.new('[\r]?[\n]')
      content.split(newline).each do |line|
        if stripped = line.lstrip!
          line = "\t" + stripped
        end
        lines.push(line)
      end
      content = lines.join("\n")
    end
    content
  end

end


class CodeRunnerTests < ActionController::TestCase

  #include CodeRunner

  ROOT_TEST_DIR = RAILS_ROOT + '/test/code_runner'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end
  
  def test_visible_and_hidden_files_are_copied_to_sandbox_and_output_is_generated
    root_test_dir_reset
    language = 'Dummy'
    language_dir = RAILS_ROOT +  '/test/functional/filesets/language/' + language
    fileset = LanguageFileset.new(language_dir)
    
    temp_dir = '12345678'
    sandbox_dir = ROOT_TEST_DIR + '/' + temp_dir    
    visible_files = fileset.visible_files
    
    Dir.mkdir sandbox_dir    
    output = CodeRunner::inner_run(sandbox_dir, language_dir, visible_files)
    
    assert_equal true, File.exists?(sandbox_dir), "sandbox dir created"
    
    visible_files.each do |filename,content|
      assert_equal true, File.exists?(sandbox_dir + '/' + filename), "File.exists? #{sandbox_dir}/#{filename}"
    end
    
    fileset.hidden_filenames.each do |filename|
      assert_equal true, File.exists?(sandbox_dir + '/' + filename), "File.exists? #{sandbox_dir}/#{filename}"
    end
    
    assert_equal true, output != nil, "output != nil"
    assert_equal true, output.include?('<54> expected but was'), "output.include?('<54>...')"
  end    
      
  def test_sandbox_dir_is_deleted_after_run
    root_test_dir_reset
    language = 'Dummy'
    language_dir = RAILS_ROOT +  '/test/functional/filesets/language/' + language
    fileset = LanguageFileset.new(language_dir)
    
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    sandbox_dir = ROOT_TEST_DIR + '/' + temp_dir    
    visible_files = fileset.visible_files
    
    output = CodeRunner::run(sandbox_dir, language_dir, visible_files)
    
    assert_equal true, !File.exists?(sandbox_dir), "!File.exists?(#{sandbox_dir})"
  end
      
end

